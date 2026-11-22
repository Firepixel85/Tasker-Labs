extends Node

const ID = "core.store_manager"
const PLUGIN_LIST_URL = "https://raw.githubusercontent.com/Rosepen-Studios/tasker-Plugin-Store/main/plugin_list.json"
var plugin_list:Dictionary = {}


func _load_plugin_list():
	Debug.log("Loading plugin list from remote repo...",ID)
	var http = HTTPRequest.new()
	add_child(http)
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
	http.request(PLUGIN_LIST_URL,headers)
	var response = await http.request_completed
	var code = response[1]
	var body = JSON.parse_string(response[3].get_string_from_utf8())
	match code:
		200:
			plugin_list = body
			Debug.log("Plugin list loaded successfully.",ID)
		404:
			Debug.error("Plugin list not found at URL: "+PLUGIN_LIST_URL,ID)
			return ERR_FILE_NOT_FOUND
		403:
			Debug.error("Access to plugin list denied.",ID)
			return ERR_FILE_NO_PERMISSION
		_:
			Debug.error("Failed to load plugin list. HTTP response code: "+str(code),ID)
			return ERR_UNAVAILABLE
	return OK

func get_plugin_for_category(category:String) -> Array:
	var list = []
	for plugin in plugin_list:
		if plugin["category"] == category:
			list.append(plugin)
	return list

func get_plugin_name(plugin_id:String) -> String:
	if !plugin_list.has(plugin_id):
		Debug.warn("A process attempted to get the name of a plugin that does not exist in the plugin list. Plugin ID: "+plugin_id,ID)
		return ""

	return plugin_list[plugin_id]["name"]

func get_plugin_description(plugin_id:String) -> String:
	if !plugin_list.has(plugin_id):
		Debug.warn("A process attempted to get the description of a plugin that does not exist in the plugin list. Plugin ID: "+plugin_id,ID)
		return ""

	return plugin_list[plugin_id]["description"]

func get_plugin_category(plugin_id:String) -> String:
	if !plugin_list.has(plugin_id):
		Debug.warn("A process attempted to get the category of a plugin that does not exist in the plugin list. Plugin ID: "+plugin_id,ID)
		return ""

	return plugin_list[plugin_id]["category"]

func get_plugin_icon(plugin_id:String) -> String:
	if !plugin_list.has(plugin_id):
		Debug.warn("A process attempted to get the icon of a plugin that does not exist in the plugin list. Plugin ID: "+plugin_id,ID)
		return ""

	return plugin_list[plugin_id]["icon"]

func get_plugin_author(plugin_id:String) -> String:
	if !plugin_list.has(plugin_id):
		Debug.warn("A process attempted to get the author of a plugin that does not exist in the plugin list. Plugin ID: "+plugin_id,ID)
		return ""

	return plugin_list[plugin_id]["author"]

func get_download_url(plugin_id:String):
	if !plugin_list.has(plugin_id):
		Debug.warn("A process attempted to get the download URL of a plugin that does not exist in the plugin list. Plugin ID: "+plugin_id,ID)
		return ""

	var latest_compatible_tag = ""

	for tag in plugin_list[plugin_id]["versions"]:
		if tag.split("_").size() != 2:
			Debug.warn("Invald version tag detected for plugin "+plugin_id+". Tag: "+tag,ID)
			continue
		var target_version = tag.split("_")[1]
		if version_compatible(target_version):
			latest_compatible_tag = tag
			break

	if latest_compatible_tag == "":
		Debug.warn("Plugin: "+plugin_id+" has no versions compatible with this API version",ID)
		return ERR_UNAVAILABLE
	return plugin_list[plugin_id]["repo"]+"/releases/download/"+latest_compatible_tag+"/plugin.zip"

func version_compatible(version:String):
	var target_major_version = version.split(".")[0]
	var target_minor_version = version.split(".")[1]
	var current_major_version = Main.get_plugin_api_version().split(".")[0]
	var current_minor_version = Main.get_plugin_api_version().split(".")[1]
	if target_major_version != current_major_version:
		return false
	if int(target_minor_version) > int(current_minor_version):
		return false
	return true
