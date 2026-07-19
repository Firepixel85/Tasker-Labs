extends Node

const ID = "core.plugin_manager"
const trusted_developers = ["rosepen"]
signal ready_to_load
signal scanned_for_updates

var _plugins = {}
var _developer_plugins = {}
var _loaded_plugins = []
var _loaded_plugin_scripts = {}
var _error_queue = []
var outdated_plugins = null
var _outdated_plugin_latest_tags = {}
var rate_limited: bool = false

func _ready() -> void:
	if DirAccess.open("user://").dir_exists("plugins"):
		Debug.log("Located plugins directory", ID)
		ready_to_load.emit()
		return
	var files = DirAccess.open("user://")
	Debug.log("Plugins directory not found, creating now", ID)
	files.make_dir("plugins")
	ready_to_load.emit()

func get_plugin_name(plugin_id: String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["name"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["name"]
	Debug.warn("A process attempted to get the name of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
	return ERR_DOES_NOT_EXIST

func get_plugin_version(plugin_id: String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["version"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["version"]
	Debug.warn("A process attempted to get the version of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
	return ERR_DOES_NOT_EXIST

func get_plugin_author(plugin_id: String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["author"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["author"]
	Debug.warn("A process attempted to get the author of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
	return ERR_DOES_NOT_EXIST

func get_plugin_target_versions(plugin_id: String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["target_api_version"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())["target_api_version"]
	Debug.warn("A process attempted to get the target versions of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
	return ERR_DOES_NOT_EXIST

func get_plugin_description(plugin_id: String):
	if !is_plugin_available(plugin_id):
		Debug.warn("A process attempted to get the description of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
		return ERR_DOES_NOT_EXIST
	if !plugin_has_description(plugin_id):
		return ""

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info["description"]
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info["description"]
	Debug.warn("A process attempted to get the description of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
	return ERR_DOES_NOT_EXIST

func get_plugin_icon(plugin_id: String):
	if !is_plugin_available(plugin_id):
		Debug.warn("A process attempted to get the icon of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
		return ERR_DOES_NOT_EXIST
	if !plugin_has_icon(plugin_id):
		Debug.warn("A process attempted to get the icon of a plugin with id: "+plugin_id+" but it doesn't have one", ID)
		return ERR_FILE_NOT_FOUND

	if _plugins.has(plugin_id):
		return ImageTexture.create_from_image(Image.load_from_file(OS.get_user_data_dir()+"/plugins/"+_plugins[plugin_id]+"/icon.png"))
	elif _developer_plugins.has(plugin_id):
		return load("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/icon.png")
	Debug.warn("A process attempted to get the icon of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
	return ERR_DOES_NOT_EXIST

func get_plugin_filepath(plugin_id: String):
	if !get_all_plugins().has(plugin_id):
		Debug.warn("A process attempted to get the filepath of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
		return ERR_DOES_NOT_EXIST
	if _plugins.has(plugin_id):
		return "res://Plugins/"+_plugins[plugin_id]+"/"
	elif _developer_plugins.has(plugin_id):
		return "res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/"

func get_plugin_repo(plugin_id: String):
	if !is_plugin_available(plugin_id):
		Debug.warn("A process attempted to get the repo of a plugin with id: "+plugin_id+" but it doesn't exist", ID)
		return ERR_DOES_NOT_EXIST
	if !is_plugin_version_controlled(plugin_id):
		Debug.warn("A process attempted to get the repo of a plugin with id: "+plugin_id+" but it isn't version controlled", ID)
		return ERR_FILE_NOT_FOUND

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info["repo"]
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info["repo"]

func get_plugin_repo_site(plugin_id: String):
	var repo_url = get_plugin_repo(plugin_id)
	if int(repo_url) == ERR_DOES_NOT_EXIST or int(repo_url) == ERR_FILE_NOT_FOUND:
		Debug.warn("A process attempted to get the repo site of a plugin with id: "+plugin_id+" but it doesn't exist or isn't version controlled", ID)
		return repo_url
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_url_completed)
	var headers
	if Network.GitHubAuth.is_authorized():
		headers = [
			"User-Agent: Tasker",
			"Authorization: Bearer %s" % Network.GitHubAuth.get_access_token(),
			"Accept: application/vnd.github+json",
			"X-GitHub-Api-Version: 2022-11-28"
		]
	else:
		headers = ["User-Agent: Tasker"]
	http_request.request(repo_url, headers)
	await _request_url_completed
	return _url_response["html_url"]

var _url_response
signal _request_url_completed
func _on_request_url_completed(_result, response_code, _headers, body):
	rate_limited = false
	if response_code == 404:
		_url_response = 404
		_request_completed.emit()
		return
	if response_code == 403:
		if JSON.parse_string(body.get_string_from_utf8())["message"].begins_with("API rate limit exceeded"):
			rate_limited = true
			Debug.warn("GitHub API rate limit exceeded, some plugin update checks will fail", ID)
		_url_response = 403
		_request_completed.emit()
		return
	if response_code != 200:
		_url_response = 000
		_request_completed.emit()
		return
	_url_response = JSON.parse_string(body.get_string_from_utf8())
	_request_url_completed.emit()

func plugin_has_description(plugin_id: String):
	if !is_plugin_available(plugin_id):
		Debug.warn("A process attempted to check if a plugin with id: "+plugin_id+" has a description but it doesn't exist", ID)
		return ERR_DOES_NOT_EXIST

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info.has("description")
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info.has("description")

func plugin_has_icon(plugin_id: String):
	if !is_plugin_available(plugin_id):
		Debug.warn("A process attempted to check if a plugin with id: "+plugin_id+" has an icon but it doesn't exist", ID)
		return ERR_DOES_NOT_EXIST

	if _plugins.has(plugin_id):
		return FileAccess.file_exists("user://plugins/"+_plugins[plugin_id]+"/icon.png")
	elif _developer_plugins.has(plugin_id):
		return ResourceLoader.exists("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/icon.png")

func is_plugin_trusted(plugin_id: String):
	if trusted_developers.has(plugin_id.split(".")[1]):
		return true
	else:
		return false

func is_plugin_version_controlled(plugin_id: String):
	if !is_plugin_available(plugin_id):
		Debug.warn("A process attempted to check if a plugin with id: "+plugin_id+" is version controlled but it doesn't exist", ID)
		return false

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info.has("repo")
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json", FileAccess.READ).get_as_text())
		return plugin_info.has("repo")

func scan_available_plugins():
	Debug.log("Scanning for available plugins...", ID)
	_plugins.clear()
	_developer_plugins.clear()
	outdated_plugins = null
	var dir = DirAccess.open("user://plugins")
	dir.list_dir_begin()
	var folder_name = dir.get_next()
	while folder_name != "":
		if dir.current_is_dir() and not folder_name.begins_with("."):
			var plugin_status = _verify_plugin(folder_name)
			if int(plugin_status) != ERR_INVALID_DATA:
				_plugins[plugin_status] = folder_name
				Debug.log("Found plugin: "+get_plugin_name(plugin_status), ID)
		folder_name = dir.get_next()
	dir.list_dir_end()

	#Developer Plugins
	if !Settings.get_option_value("core.developer/dev_tools"):
		return OK
	dir = DirAccess.open("res://DeveloperPlugins")
	dir.list_dir_begin()
	folder_name = dir.get_next()
	while folder_name != "":
		if dir.current_is_dir() and not folder_name.begins_with("."):
			var plugin_status = _verify_plugin(folder_name, "res://DeveloperPlugins/")
			if int(plugin_status) != ERR_INVALID_DATA:
				_developer_plugins[plugin_status] = folder_name
				Debug.log("Found developer plugin: "+get_plugin_name(plugin_status), ID)
		folder_name = dir.get_next()
	dir.list_dir_end()
	return OK

func _load_data():
	if Data.file_exists("Core/PluginData"):
		var data = Data.load_file("Core/PluginData")
		for plugin_id in data["loaded_plugins"]:
			load_plugin(plugin_id)
	else:
		Data.make_file("PluginData", "Core")
		save_data()

func _verify_plugin(plugin_file_name: String, file_path: String = "user://plugins/"):
	if !FileAccess.file_exists(file_path+plugin_file_name+"/info.json"):
		Debug.log("Plugin "+plugin_file_name+" is missing info.json file, skipping...", ID)
		return

	var file = FileAccess.open(file_path+plugin_file_name+"/info.json", FileAccess.READ)
	var plugin_info: Dictionary = JSON.parse_string(file.get_as_text())

	if plugin_info == null:
		Debug.error("Plugin "+plugin_file_name+" has invalid info.json file, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_file_name+" because it is missing required info")
		return ERR_INVALID_DATA
	if !plugin_info.has("target_api_version"):
		Debug.error("Plugin "+plugin_file_name+" did not specify a compatible API version, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_file_name+" did not specify a compatible API version, skipping...")
		return ERR_INVALID_DATA
	if !version_compatible(plugin_info["target_api_version"]):
		Debug.error("Plugin "+plugin_file_name+" is not compatible with the current API version, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_file_name+" because it is not compatible with the current API version")
		return ERR_INVALID_DATA
	if !plugin_info.has("name"):
		Debug.error("Plugin "+plugin_file_name+" is missing name field in info.json file, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_file_name+" because it is missing name info")
		return ERR_INVALID_DATA
	var plugin_name = plugin_info["name"]
	if !plugin_info.has("version"):
		Debug.error("Plugin "+plugin_file_name+" is missing version field in info.json file, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_name+" because it is missing version info")
		return ERR_INVALID_DATA
	if !plugin_info.has("author"):
		Debug.error("Plugin "+plugin_file_name+" is missing author field in info.json file, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_name+" because it is missing author info")
		return ERR_INVALID_DATA
	if !plugin_info.has("plugin_id"):
		Debug.error("Plugin "+plugin_file_name+" is missing plugin_id field in info.json file, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_name+" because it is missing plugin_id info")
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].begins_with("com."):
		Debug.error("Plugin "+plugin_file_name+" has invalid plugin_id field in info.json file, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_name+" because it has an invalid plugin_id (must begin with com.)")
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].split(".").size() == 3:
		Debug.error("Plugin "+plugin_file_name+" has invalid plugin_id filed in info.json, skipping...", ID)
		_error_queue.append("Couldn't load "+plugin_name+" because it has an invalid plugin_id (must be in format com.author.plugin_name)")
		return ERR_INVALID_DATA
	if _plugins.has(plugin_info["plugin_id"]):
		Debug.error("Plugin "+plugin_file_name+" has the same id as a previous plugin", ID)
		_error_queue.append("Couldn't load "+plugin_name+" because its plugin_id is the same as another plugin")
		return ERR_INVALID_DATA
	if !FileAccess.file_exists("user://plugins/"+plugin_file_name+"/plugin.pck") and file_path == "user://plugins/":
		_error_queue.append("Couldn't load "+plugin_name+" because it is missing files essential for it to run (plugin.pck)")
		Debug.log("Plugin "+plugin_file_name+" is missing plugin.pck file, skipping...", ID)
		return ERR_INVALID_DATA

	return plugin_info["plugin_id"]

func load_plugin(plugin_id):
	if !get_all_plugins().has(plugin_id):
		Debug.error("Could't load plugin with id: "+plugin_id+", plugin not found", ID)
		return ERR_DOES_NOT_EXIST
	if _plugins.has(plugin_id):
		Debug.log("Loading plugin: "+get_plugin_name(plugin_id), ID)
		ProjectSettings.load_resource_pack("user://plugins/"+_plugins[plugin_id]+"/plugin.pck")
		_loaded_plugin_scripts[plugin_id] = load("res://Plugins/"+_plugins[plugin_id]+"/plugin.gd").new()
		if !_loaded_plugin_scripts[plugin_id].has_method("start") and _loaded_plugin_scripts[plugin_id].has_method("stop"):
			Debug.error("Plugin with id: "+plugin_id+" does not have required start and stop methods, didn't load", ID)
			_loaded_plugin_scripts.erase(plugin_id)
			return ERR_METHOD_NOT_FOUND
		_loaded_plugin_scripts[plugin_id].start()
		_loaded_plugins.append(plugin_id)
		save_data()
		return OK
	elif is_developer_plugin(plugin_id) and Settings.get_option_value("core.developer/dev_tools"):
		Debug.log("Loading developer plugin: "+get_plugin_name(plugin_id), ID)
		if !FileAccess.file_exists("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/plugin.gd"):
			NotificationManager.queue_notification(
				"Couldn't load plugin: %s"%get_plugin_name(plugin_id),
				"The plugin is missing the required script for it to be loaded. Please report this to the author.",
				true,
				null,
				[],
				0.0
			)
			if Main.get_current_view() != "mainview":
				RoseGarden.create_toast("Couldn't load plugin", "Red")
			Debug.error("Plugin with id: "+plugin_id+" does not have required plugin.gd script, didn't load", ID)
			return ERR_FILE_NOT_FOUND
		_loaded_plugin_scripts[plugin_id] = load("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/plugin.gd").new()
		if !_loaded_plugin_scripts[plugin_id].has_method("start") and _loaded_plugin_scripts[plugin_id].has_method("stop"):
			NotificationManager.queue_notification(
				"Couldn't load plugin: %s"%get_plugin_name(plugin_id),
				"The plugin has a malformed plugin script. Please report this to the author.",
				true,
				null,
				[],
				0.0
			)
			Debug.error("Plugin with id: "+plugin_id+" does not have required start and stop methods, didn't load", ID)
			_loaded_plugin_scripts.erase(plugin_id)
			return ERR_METHOD_NOT_FOUND
		_loaded_plugin_scripts[plugin_id].start()
		_loaded_plugins.append(plugin_id)
		save_data()
		return OK
	Debug.error("Could't load plugin with id: "+plugin_id+", because developer plugins are disabled", ID)
	return ERR_LOCKED

func unload_plugin(plugin_id: String):
	if !_loaded_plugins.has(plugin_id):
		Debug.error("Could't unload plugin with id: "+plugin_id+", plugin not found or not loaded", ID)
		return ERR_DOES_NOT_EXIST

	_loaded_plugins.erase(plugin_id)
	_loaded_plugin_scripts[plugin_id].stop()
	_loaded_plugin_scripts.erase(plugin_id)
	Debug.log("Unloaded plugin: "+get_plugin_name(plugin_id), ID)
	save_data()
	return OK

func is_developer_plugin(plugin_id):
	if _developer_plugins.has(plugin_id):
		return true
	else:
		return false

func is_plugin_available(plugin_id):
	if _plugins.has(plugin_id) or _developer_plugins.has(plugin_id):
		return true
	else:
		return false

func is_plugin_loaded(plugin_id):
	if _loaded_plugins.has(plugin_id):
		return true
	else:
		return false

func get_all_plugins():
	var plugin_list = []
	for plugin_id in _plugins.keys():
		plugin_list.append(plugin_id)
	for plugin_id in _developer_plugins.keys():
		plugin_list.append(plugin_id)
	return plugin_list

func save_data():
	Data.save_to("loaded_plugins", _loaded_plugins, "Core/PluginData")
	Data.save_file("Core/PluginData")


func get_plugin_script(plugin_id: String):
	if !is_plugin_loaded(plugin_id):
		Debug.warn("A process attempted to get the script of a plugin with id: "+plugin_id+" but it isn't loaded", ID)
		return ERR_DOES_NOT_EXIST
	return _loaded_plugin_scripts[plugin_id]

func _send_errors():
	for error in _error_queue:
		NotificationManager.queue_notification("Plugin Load Error", error, true, null, [], 0.0)
	_error_queue.clear()

signal _request_completed
var _response
func scan_for_updates():
	Debug.log("Scanning for available updates...", ID)
	outdated_plugins = []
	for plugin_id in get_all_plugins():
		if !is_plugin_version_controlled(plugin_id):
			continue
		var repo_url = get_plugin_repo(plugin_id)
		var plugin_name = get_plugin_name(plugin_id)
		var plugin_version = get_plugin_version(plugin_id)

		var http_request = HTTPRequest.new()
		add_child(http_request)
		http_request.request_completed.connect(_on_request_completed)
		var headers
		if Network.GitHubAuth.is_authorized():
			headers = [
				"User-Agent: Tasker",
				"Authorization: Bearer %s" % Network.GitHubAuth.get_access_token(),
				"Accept: application/vnd.github+json",
				"X-GitHub-Api-Version: 2022-11-28"
			]
		else:
			headers = ["User-Agent: Tasker"]
		http_request.request(repo_url+"/releases", headers)
		await _request_completed

		match _response:
			404:
				Debug.error("Plugin "+plugin_name+" provided an invalid repository for version control, update check failed (404)", ID)
				continue
			403:
				Debug.error("Plugin "+plugin_name+" appears to have it's repository private or restricted, update check failed (403)", ID)
				continue
			null:
				Debug.error(plugin_name+" plugin's repository sent an invalid respons update check failed", ID)
				continue
			000:
				Debug.error("Plugin "+plugin_name+" update check failed, unknown error", ID)
				continue
			_:
				#latest_version = response["tag_name"]
				var tags = []
				for release in _response:
					tags.append(release["tag_name"])
				if tags[0].split("_")[0] != plugin_version:
					var latest_compatible_version = ""
					var latest_compatible_tag = ""
					for tag in tags:
						if tag.split("_").size() != 2:
							break
						var version = tag.split("_")[0]
						var target_version = tag.split("_")[1]
						if version != plugin_version and version_compatible(target_version):
							latest_compatible_version = version
							latest_compatible_tag = tag
							break
						elif version == plugin_version:
							latest_compatible_version = version
							break
					if latest_compatible_version == "":
						Debug.log("Encountered an error while checking for updates for plugin "+plugin_name+", no compatible version found", ID)
					elif latest_compatible_version == plugin_version:
						Debug.log("No compatible updates found for plugin "+plugin_name+", it is up to date for this version of Tasker", ID)
					else:
						outdated_plugins.append(plugin_id)
						_outdated_plugin_latest_tags[plugin_id] = latest_compatible_tag
						Debug.log("Plugin "+plugin_name+" has an update available! Current version: "+plugin_version+", Latest version: "+latest_compatible_version, ID)
				else:
					Debug.log("Plugin "+plugin_name+" is up to date! Current version: "+plugin_version, ID)

	var result : = []
	for item in outdated_plugins:
		if item not in result:
			result.append(item)
	outdated_plugins = result

	Debug.log("Finished scanning for available updates", ID)
	scanned_for_updates.emit()
	return OK

func _on_request_completed(_result, response_code, _headers, body):
	rate_limited = false
	if response_code == 404:
		_response = 404
		_request_completed.emit()
		return
	if response_code == 403:
		if JSON.parse_string(body.get_string_from_utf8())["message"].begins_with("API rate limit exceeded"):
			rate_limited = true
			Debug.warn("GitHub API rate limit exceeded, some plugin update checks will fail", ID)
		_response = 403
		_request_completed.emit()
		return
	if response_code != 200:
		_response = 000
		_request_completed.emit()
		return
	_response = JSON.parse_string(body.get_string_from_utf8())
	_request_completed.emit()

func version_compatible(version: String):
	var target_major_version = version.split(".")[0]
	var target_minor_version = version.split(".")[1]
	var current_major_version = Main.get_plugin_api_version().split(".")[0]
	var current_minor_version = Main.get_plugin_api_version().split(".")[1]
	if target_major_version != current_major_version:
		return false
	if int(target_minor_version) > int(current_minor_version):
		return false
	return true

func get_outdated_plugins():
	return outdated_plugins

func get_plugin_latest_version(plugin_id: String):
	if !outdated_plugins.has(plugin_id):
		Debug.warn("A process attempted to get the latest version of a plugin with id: "+plugin_id+" but it isn't outdated", ID)
		return ERR_DOES_NOT_EXIST
	return _outdated_plugin_latest_tags[plugin_id].split("_")[0]

func get_plugin_latest_tag(plugin_id: String):
	if !outdated_plugins.has(plugin_id):
		Debug.warn("A process attempted to get the latest tag of a plugin with id: "+plugin_id+" but it isn't outdated", ID)
		return ERR_DOES_NOT_EXIST
	return _outdated_plugin_latest_tags[plugin_id]

func is_rate_limited():
	return rate_limited

func update_plugin(plugin_id: String):
	Debug.log("Updating plugin with id: "+plugin_id, ID)
	var load_again = false
	if is_plugin_loaded(plugin_id):
		load_again = true
		unload_plugin(plugin_id)
	if !outdated_plugins.has(plugin_id):
		Debug.warn("A process attempted to update a plugin with id: "+plugin_id+" but it isn't outdated", ID)
		return ERR_DOES_NOT_EXIST

	var http_request = HTTPRequest.new()
	add_child(http_request)
	var url = get_plugin_repo(plugin_id)+"/releases/tags/%s"%get_plugin_latest_tag(plugin_id)
	var headers
	if Network.GitHubAuth.is_authorized():
		headers = [
			"User-Agent: Tasker",
			"Authorization: Bearer %s" % Network.GitHubAuth.get_access_token(),
			"Accept: application/vnd.github+json",
			"X-GitHub-Api-Version: 2022-11-28"
		]
	else:
		headers = ["User-Agent: Tasker"]
	http_request.request(url, headers)
	var response = await http_request.request_completed
	var code = response[1]
	var body = JSON.parse_string(response[3].get_string_from_utf8())
	if code == 404:
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" provided an invalid repository for version control, update check failed (404)", ID)
		return ERR_DOES_NOT_EXIST
	elif  code == 403:
		if JSON.parse_string(response[3].get_string_from_utf8())["message"].begins_with("API rate limit exceeded"):
			rate_limited = true
			Debug.warn("GitHub API rate limit exceeded, some plugin update checks will fail", ID)
			return ERR_LOCKED
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" appears to have it's repository private or restricted, update check failed (403)", ID)
		return ERR_FILE_NO_PERMISSION
	elif code != 200:
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update check failed, unknown error", ID)
		return ERR_CANT_CONNECT
	elif body == null:
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update check failed, server sent invalid response", ID)
		return ERR_INVALID_DATA

	var download_url : = ""
	for asset in body["assets"]:
		if asset["name"] == "plugin.zip":
			download_url = asset["browser_download_url"]
			break

	if download_url == "":
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update check failed, no plugin.zip asset found in release", ID)
		return ERR_CANT_ACQUIRE_RESOURCE

	var download_http = HTTPRequest.new()
	add_child(download_http)
	download_http.download_file = "user://plugin.zip"
	download_http.request(download_url, headers)

	var download_response = await download_http.request_completed
	download_http.queue_free()

	var download_code: int = download_response[1]
	if download_code == 404:
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update download failed, plugin.zip asset not found (404)", ID)
		return ERR_DOES_NOT_EXIST
	elif download_code == 403:
		if JSON.parse_string(download_response[3].get_string_from_utf8())["message"].begins_with("API rate limit exceeded"):
			rate_limited = true
			Debug.warn("GitHub API rate limit exceeded, some plugin update downloads will fail", ID)
			return ERR_LOCKED
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update download failed, access to plugin.zip asset denied (403)", ID)
		return ERR_FILE_NO_PERMISSION
	elif download_code != 200:
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update download failed, unknown error (%s)"%download_code, ID)
		return ERR_CANT_CONNECT

	Debug.log("Plugin "+get_plugin_name(plugin_id)+" update downloaded successfully, extracting...", ID)
	var zip = ZIPReader.new()

	var error = zip.open("user://plugin.zip")
	if error != OK:
		Debug.error("Plugin "+get_plugin_name(plugin_id)+" update extraction failed, unable to open zip file", ID)
		return ERR_CANT_OPEN

	for path in zip.get_files():
		var file_data = zip.read_file(path)
		var dir_path = path.get_base_dir()
		if not dir_path.is_empty():
			DirAccess.make_dir_recursive_absolute("user://%s" % dir_path)
		var output_file = FileAccess.open("user://%s" % path, FileAccess.WRITE)
		if output_file == null:
			Debug.error("Failed to write file: %s" % path, ID)
			continue
		output_file.store_buffer(file_data)
		output_file.close()
	zip.close()

	var dir = DirAccess.open("user://")
	if dir == null:
		Debug.error("Failed to open user directory for deleting zip file", ID)
		return ERR_CANT_OPEN

	var delete_err = dir.remove("plugin.zip")
	if delete_err != OK:
		Debug.error("Failed to delete plugin.zip after extraction, additional clean-up needed", ID)
	var existing_plugin_path = "user://plugins/%s" % _plugins[plugin_id]
	if DirAccess.dir_exists_absolute(existing_plugin_path):
		var delete_dir_err = OS.move_to_trash(ProjectSettings.globalize_path(existing_plugin_path))
		if delete_dir_err != OK:
			Debug.error("Failed to move old plugin directory to trash after update, additional clean-up needed", ID)
			return ERR_CANT_RESOLVE

	var source_path = "user://%s" % _plugins[plugin_id]
	if not DirAccess.dir_exists_absolute(source_path):
		Debug.error("Failed to locate extracted plugin directory after update, update failed", ID)
		return

	if not DirAccess.dir_exists_absolute("user://plugins"):
		DirAccess.make_dir_recursive_absolute("user://plugins")

	var move_err = dir.rename(
		ProjectSettings.globalize_path(source_path),
		ProjectSettings.globalize_path(existing_plugin_path)
	)
	if move_err != OK:
		Debug.error("Failed to move updated plugin directory to plugins folder, update failed", ID)
		return
	if load_again:
		load_plugin(plugin_id)
	Debug.log("Plugin "+get_plugin_name(plugin_id)+" updated successfully to version "+get_plugin_latest_version(plugin_id), ID)
	outdated_plugins.erase(plugin_id)
	return OK
