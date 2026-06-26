extends Node

signal auth_completed(token: String)
signal auth_failed(reason: String)

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
		Debug.log("Attempting to authorize with GitHub",ID)
		_server = TCPServer.new()
		var err = _server.listen(PORT)
		if err != OK:
			Debug.log("Failed to start local server on port %d" % PORT,ID)
			Network.auth_failed.emit("Could not start local server")
			return
		_poll_timer = Timer.new()
		Network.add_child(_poll_timer)
		_poll_timer.wait_time = 0.1
		_poll_timer.timeout.connect(_poll_server)
		_poll_timer.start()
		var auth_url = "https://github.com/login/oauth/authorize?client_id=%s&redirect_uri=%s&scope=public_repo" % [
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
			Debug.log("No code found in redirect",ID)
			Network.auth_failed.emit("No code in redirect")
			return
		await _exchange_code(code)

	static func _extract_code(raw_request: String) -> String:
		var first_line = raw_request.split("\n")[0]
		var query = first_line.split("?")
		if query.size() < 2:
			return ""

		for param in query[1].split("&"):
			var pair = param.split("=")
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
		var body = "client_id=%s&client_secret=%s&code=%s&redirect_uri=%s" % [
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
		Debug.log("Authorization successful, access token obtained",ID)

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
		var err = Data.remove_file("Secrets")
		if err == OK:
			access_token = ""
		return err

func save() -> void:
	Data.save_to("access_token", GitHubAuth.access_token, "Secrets")
	Data.save_file("Secrets")
	
func _ready() -> void:
	GitHubAuth.CLIENT_ID = Vault.GITHUB_CLIENT_ID
	GitHubAuth.CLIENT_SECRET = Vault.GITHUB_CLIENT_SECRET
	if Data.file_exists("Secrets"):
		var data = Data.load_file("Secrets")
		if data.has("access_token"):
			GitHubAuth.access_token = data["access_token"]
	else:
		Data.make_file("Secrets")
		save()
