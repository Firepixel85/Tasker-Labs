extends Node

signal auth_completed(token: String)
signal auth_failed(reason: String)

signal check_for_updates(latest_version: String, is_outdated: bool)

const ID = "core.network"

class GitHubAuth:
	static var CLIENT_ID
	static var CLIENT_SECRET
	const REDIRECT_URI = "http://localhost:7458/callback"
	const PORT = 7458
	const ID = "core.network.githubauth"

	static var _server: TCPServer
	static var _poll_timer: Timer
	static var access_token: String = ""

	static func authorize() -> void:
		Debug.log("Attempting to authorize with GitHub", ID)
		_server = TCPServer.new()
		var err = _server.listen(PORT)
		if err != OK:
			Debug.log("Failed to start local server on port %d" % PORT, ID)
			Network.auth_failed.emit("Could not start local server")
			return
		_poll_timer = Timer.new()
		Network.add_child(_poll_timer)
		_poll_timer.wait_time = 0.1
		_poll_timer.timeout.connect(_poll_server)
		_poll_timer.start()
		var auth_url = "https://github.com/login/oauth/authorize?client_id = %s&redirect_uri = %s&scope = public_repo" % [
			CLIENT_ID,
			REDIRECT_URI
		]
		OS.shell_open(auth_url)

	static func _poll_server() -> void:
		if not _server.is_connection_available():
			return

		var peer = _server.take_connection()
		var raw = ""

		while peer.get_status() == StreamPeerTCP.STATUS_CONNECTED:
			var bytes = peer.get_available_bytes()
			if bytes > 0:
				raw += peer.get_string(bytes)
				break
			await Network.get_tree().process_frame
		var html = "<html><body><h3>You can close this tab and return to Tasker.</h3></body></html>"
		var response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: %d\r\nConnection: close\r\n\r\n%s" % [
			html.length(), html
		]
		peer.put_data(response.to_utf8_buffer())
		peer.disconnect_from_host()
		_shutdown_server()
		var code = _extract_code(raw)
		if code.is_empty():
			Debug.log("No code found in redirect", ID)
			Network.auth_failed.emit("No code in redirect")
			return
		await _exchange_code(code)

	static func _extract_code(raw_request: String) -> String:
		var first_line = raw_request.split("\n")[0]
		var query = first_line.split("?")
		if query.size() < 2:
			return ""

		for param in query[1].split("&"):
			var pair = param.split(" = ")
			if pair.size() == 2 and pair[0] == "code":
				return pair[1].strip_edges()
		return ""

	static func _exchange_code(code: String) -> void:
		var http = HTTPRequest.new()
		Network.add_child(http)
		var headers = [
			"Accept: application/json",
			"Content-Type: application/x-www-form-urlencoded"
		]
		var body = "client_id = %s&client_secret = %s&code = %s&redirect_uri = %s" % [
			CLIENT_ID, CLIENT_SECRET, code.split(" ")[0], REDIRECT_URI
		]
		http.request(
			"https://github.com/login/oauth/access_token",
			headers,
			HTTPClient.METHOD_POST,
			body
		)
		var response = await http.request_completed
		http.queue_free()
		var response_code: int = response[1]
		var response_body: PackedByteArray = response[3]
		if response_code != 200:
			Network.auth_failed.emit("Token exchange failed: %d" % response_code)
			Debug.log("Token exchange failed: %d" % response_code, ID)
			return
		var json = JSON.parse_string(response_body.get_string_from_utf8())
		if json == null or not json.has("access_token"):
			Network.auth_failed.emit("No access_token in response")
			Debug.log("No access_token in response, code: %s"%str(code), ID)
			return
		access_token = json["access_token"]
		Network.save()
		Network.auth_completed.emit(access_token)
		Debug.log("Authorization successful, access token obtained", ID)

	static func _shutdown_server() -> void:
		if _poll_timer:
			_poll_timer.stop()
			_poll_timer.queue_free()
			_poll_timer = null
		if _server:
			_server.stop()
			_server = null

	static func is_authorized() -> bool:
		return access_token != ""

	static func get_access_token() -> String:
		return access_token

	static func disconnect_auth():
		var err = Data.remove_file("Core/Secrets")
		if err == OK:
			access_token = ""
		return err

class Updates:
	const ID = "core.network.updates"
	static var latest_version: String
	static var is_outdated: bool = false
	static var helper_version: String = ""
	static var latest_helper_version: String = ""
	static var latest_helper_download_url: String = ""
	static var updating: bool = false
	static var latest_version_description: String = ""
	static var latest_version_size: String = ""
	static var latest_version_release_date: String = ""
	static var latest_version_name: String = ""

	static func check_for_updates() -> void:
		Debug.log("Checking for updates...", ID)
		var http = HTTPRequest.new()
		Network.add_child(http)
		var headers: Array
		if Network.GitHubAuth.is_authorized():
			headers = [
				"User-Agent: Tasker",
				"Authorization: Bearer %s" % Network.GitHubAuth.get_access_token(),
				"Accept: application/vnd.github+json",
				"X-GitHub-Api-Version: 2022-11-28"
			]
		else:
			headers = ["User-Agent: Tasker"]
		var url: String
		if Main.get_version_sufix().begins_with("beta") or Main.get_version_sufix().begins_with("pb"):
			url = "https://api.github.com/repos/Firepixel85/Tasker-Labs/releases/latest"
		else:
			url = "https://api.github.com/repos/Rosepen-Studios/Tasker/releases/latest"
		http.request(url, headers)
		var response = await http.request_completed
		http.queue_free()
		match response[1]:
			404:
				Debug.log("Update check failed: Repository is missing, please report this issue (404)", ID)
				NotificationManager.queue_notification(
					"Update Check Failed", "Repository is missing, please report this issue by clicking this notification",
					true,
					OS.shell_open,
					["https://github.com/Rosepen-Studios/Tasker/issues/new/choose"],
					0.0
				)
				return
			403:
				Debug.log("Update check failed: Rate limit exceeded, please authorize with GitHub to continue (403)", ID)
				NotificationManager.queue_notification(
					"Update Check Failed", "Rate limit exceeded, please authorize with GitHub to continue. Click here to authorize.",
					true,
					Network.GitHubAuth.authorize,
					[],
					0.0
				)
				return
			200:
				var response_body: PackedByteArray = response[3]
				var json = JSON.parse_string(response_body.get_string_from_utf8())
				if json == null or not json.has("tag_name"):
					Debug.log("Update check failed: Invalid response from GitHub", ID)
					NotificationManager.queue_notification(
						"Update Check Failed", "Invalid response from GitHub, please report this issue by clicking this notification",
						true,
						OS.shell_open,
						["https://github.com/Rosepen-Studios/Tasker/issues/new/choose"],
						0.0
					)
					return
				latest_version = json["tag_name"]
				latest_version_release_date = json["published_at"].split("T")[0].replacen("-", "/")
				latest_version_name = json["name"]
				var description_url = ""
				for asset in json["assets"]:
					if asset["name"] == "Tasker.zip":
						latest_version_size = str(roundi(asset["size"]/1048576))
					if asset["name"] == "Description.txt":
						description_url = asset["browser_download_url"]
				if description_url != "":
					var desc_http = HTTPRequest.new()
					Network.add_child(desc_http)
					desc_http.download_file = "user://Description.txt"
					desc_http.request(description_url, headers)
					var desc_response = await desc_http.request_completed
					desc_http.queue_free()
					if desc_response[1] == 200:
						var desc_file = FileAccess.open("user://Description.txt", FileAccess.READ)
						latest_version_description = desc_file.get_as_text()
						desc_file.close()
						DirAccess.remove_absolute("user://Description.txt")
					else:
						Debug.log("Failed to download description file: HTTP error %d" % desc_response[1], ID)
						latest_version_description = "[color = D72D2C]Failed to download description file: HTTP error %d" % desc_response[1]
				if latest_version != Main.get_version():
					is_outdated = true
					if Settings.get_option_value("core.general/update_notify"):
						EventManager.add_event(ID, load("res://MainView/Updates/UpdateAvailableEvent.tscn"), Icons.DOWNLOAD)
					Network.check_for_updates.emit(latest_version, true)
					Debug.log("Update available: %s" % latest_version, ID)
			_:
				Debug.log("Update check failed: HTTP error %d" % response[1], ID)
				NotificationManager.queue_notification(
					"Update Check Failed", "HTTP error %d while checking for updates, please report this issue by clicking this notification" % response[1],
					true,
					OS.shell_open,
					["https://github.com/Rosepen-Studios/Tasker/issues/new/choose"],
					0.0
				)

	static func update():
		if updating:
			Debug.log("Update already in progress, ignoring request", ID)
			return
		updating = true
		Debug.log("Updating Tasker", ID)
		var popup = TSKPopup.new()
		if !helper_exist() or helper_version != latest_helper_version:
			popup.set_type(TSKPopup.SINGLE_ACTION)
			popup.set_title("Downloading Helper")
			popup.set_description("Tasker is now downloading a helper app to update. You can continue using the app normaly until the download is complete. Please do not close the app.")
			popup.add_action(empty, "Got it")
			if EventManager.event_exists(ID):
				EventManager.remove_event(ID)
			EventManager.add_event(ID, load("res://MainView/Updates/HelperDownloadingEvent.tscn"), Icons.DOWNLOAD)
			if Popups.is_popup_active():
				Popups.clear_popup()
				await Popups.popup_cleared
				Popups.create_prefab_popup(popup)
			var err = await _download_helper()
			if err != OK:
				Debug.error("Failed to download helper app, update aborted", ID)
				NotificationManager.queue_notification(
					"Update Failed", "Failed to download helper app, please report this issue by clicking this notification. Update canceled.",
					true,
					OS.shell_open,
					["https://github.com/Rosepen-Studios/Tasker/issues/new/choose"],
					0.0
				)
				EventManager.remove_event(ID)
				return
		EventManager.remove_event(ID)
		EventManager.add_event(ID, load("res://MainView/Updates/UpdateReadyEvent.tscn"), Icons.DOWNLOAD)
		popup = TSKPopup.new()
		popup.set_type(TSKPopup.DOUBLE_ACTION)
		popup.set_title("Ready to Update")
		popup.set_description("Tasker is now ready to update. If you have unsaved progress, close this popup, save your work and click on the update event on the bottom left of your screen. Otherwise, click on 'Update Now' to start the update process. Tasker will automatically close and a helper app will open.")
		popup.add_action(empty, "Not Now", [], "Gray")
		popup.add_action(_open_helper, "Update Now", [], Settings.get_option_value("core.appearance/accent_color"))
		if Popups.is_popup_active():
			Popups.clear_popup()
			await Popups.popup_cleared
		Popups.create_prefab_popup(popup)
		updating = false

	static func helper_exist():
		return DirAccess.dir_exists_absolute("user://TaskerUpdater.app")

	static func _open_helper():
		if !helper_exist():
			NotificationManager.queue_notification(
				"Update Failed", "Helper app is missing, please report this issue by clicking this notification. Update canceled.",
				true,
				OS.shell_open,
				["https://github.com/Rosepen-Studios/Tasker/issues/new/choose"],
				0.0
			)
			Debug.error("Attempting to open helper app to update, but it doesn't exist")
			return
		OS.shell_open(OS.get_user_data_dir()+"/TaskerUpdater.app")
		Network.get_tree().quit()

	static func _download_helper():
		if latest_helper_version == "" or latest_helper_download_url == "":
			var err = await _get_helper_latest_version()
			if err != OK:
				Debug.error("Failed to get latest helper version, update aborted", ID)
				NotificationManager.queue_notification(
					"Update Failed", "Failed to get latest helper version, please report this issue by clicking this notification. Update canceled.",
					true,
					OS.shell_open,
					["https://github.com/Rosepen-Studios/Tasker/issues/new/choose"],
					0.0
				)
				return err

		Debug.log("Downloading helper app version %s" % latest_helper_version, ID)

		if helper_exist() and helper_version == latest_helper_version:
			return OK

		var dir = DirAccess.open("user://")
		if dir == null:
			Debug.error("Failed to open user directory for deleting files", ID)
			return ERR_CANT_OPEN

		if helper_exist():
			if remove_recursive("user://TaskerUpdater.app") != OK:
				Debug.error("Failed to delete existing helper app, update may fail", ID)
		if FileAccess.file_exists("user://TaskerUpdater.zip"):
			if dir.remove("user://TaskerUpdater.zip") != OK:
				Debug.error("Failed to delete existing TaskerUpdater.zip, future updates may fail", ID)

		if latest_helper_download_url == "":
			Debug.log("Helper download failed: No download URL found for TaskerUpdater.zip", ID)
			return ERR_CONNECTION_ERROR

		var download_http = HTTPRequest.new()
		Network.add_child(download_http)
		var headers: Array
		if Network.GitHubAuth.is_authorized():
			headers = [
				"User-Agent: Tasker",
				"Authorization: Bearer %s" % Network.GitHubAuth.get_access_token(),
				"Accept: application/vnd.github+json",
				"X-GitHub-Api-Version: 2022-11-28"
			]
		else:
			headers = ["User-Agent: Tasker"]
		download_http.download_file = "user://TaskerUpdater.zip"
		download_http.request(latest_helper_download_url, headers)
		var download_response = await download_http.request_completed
		download_http.queue_free()

		if download_response[1] != 200:
			Debug.log("Helper download failed: HTTP error %d while downloading helper" % download_response[1], ID)
			return ERR_CONNECTION_ERROR

		Debug.log("Helper download complete, extracting...", ID)

		var output : = []
		var exit_code : = OS.execute("ditto", ["-xk", ProjectSettings.globalize_path("user://TaskerUpdater.zip"), ProjectSettings.globalize_path("user://")], output, true)

		if exit_code != 0:
			Debug.error("Helper extraction failed (ditto exit code %d): %s" % [exit_code, output], ID)
			return ERR_CANT_OPEN


		var delete_err = dir.remove("TaskerUpdater.zip")
		if delete_err != OK:
			Debug.error("Failed to delete TaskerUpdater.zip after extraction, additional clean-up needed", ID)

		helper_version = latest_helper_version
		Network.save()
		Debug.log("Helper download complete", ID)
		return OK

	static func _get_helper_latest_version():
		var http = HTTPRequest.new()
		Network.add_child(http)
		var headers: Array
		if Network.GitHubAuth.is_authorized():
			headers = [
				"User-Agent: Tasker",
				"Authorization: Bearer %s" % Network.GitHubAuth.get_access_token(),
				"Accept: application/vnd.github+json",
				"X-GitHub-Api-Version: 2022-11-28"
			]
		else:
			headers = ["User-Agent: Tasker"]
		var url: String = "https://api.github.com/repos/Rosepen-Studios/Tasker-Updater/releases/latest"
		http.request(url, headers)
		var response = await http.request_completed
		http.queue_free()
		match response[1]:
			404:
				return ERR_CONNECTION_ERROR
			403:
				return ERR_CONNECTION_ERROR
			200:
				var response_body: PackedByteArray = response[3]
				var json = JSON.parse_string(response_body.get_string_from_utf8())
				if json == null or !json.has("tag_name"):
					return ERR_CONNECTION_ERROR
				latest_helper_version = json["tag_name"]
				for asset in json["assets"]:
					if asset["name"] == "TaskerUpdater.zip":
						latest_helper_download_url = asset["browser_download_url"]
						break
				return latest_helper_version
			_:
				return ERR_CONNECTION_ERROR

	static func empty(): #I challenge you to find all empty functions in the codebase
		pass

	#Helper:
	static func remove_recursive(path: String) -> Error:
		var dir = DirAccess.open(path)
		if dir == null:
			return DirAccess.get_open_error()

		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name != "." and file_name != "..":
				var full_path = path.path_join(file_name)
				if dir.current_is_dir():
					var err = remove_recursive(full_path)
					if err != OK:
						return err
				else:
					var err = DirAccess.remove_absolute(full_path)
					if err != OK:
						return err
			file_name = dir.get_next()
		dir.list_dir_end()
		return DirAccess.remove_absolute(path)

	static func _settings_update(option_path, new_value):
		if option_path != "core.general/update_notify":
			return
		if new_value == true:
			Updates.check_for_updates()
		elif EventManager.event_exists(ID):
			EventManager.remove_event(ID)

func save() -> void:
	Data.save_to("access_token", GitHubAuth.access_token, "Core/Secrets")
	Data.save_file("Core/Secrets")
	Data.save_to("helper_version", Updates.helper_version, "Core/UpdateData")
	Data.save_to("version", Main.get_version(), "Core/UpdateData")
	Data.save_to("version_sufix", Main.get_version_sufix(), "Core/UpdateData")
	Data.save_file("Core/UpdateData")

func _ready() -> void:
	GitHubAuth.CLIENT_ID = Vault.GITHUB_CLIENT_ID
	GitHubAuth.CLIENT_SECRET = Vault.GITHUB_CLIENT_SECRET
	if Data.file_exists("Core/Secrets"):
		var data = Data.load_file("Core/Secrets")
		if data.has("access_token"):
			GitHubAuth.access_token = data["access_token"]
	else:
		Data.make_file("Secrets", "Core")
		save()
	if Data.file_exists("Core/UpdateData"):
		var data = Data.load_file("Core/UpdateData")
		if data.has("helper_version"):
			Updates.helper_version = data["helper_version"]
	else:
		Data.make_file("UpdateData", "Core")
		save()
	Main.view_changed.connect(_on_view_changed)
	Updates._get_helper_latest_version()
	Settings.setting_changed.connect(Updates._settings_update)

func _on_view_changed(new_view: String) -> void:
	if new_view != "settings" or Settings.get_option_value("core.general/update_notify"):
		return
	var new_setting = await Settings.setting_changed
	if new_setting[0] == "core.general/update_notify" and new_setting[1] == true:
		Updates.check_for_updates()
