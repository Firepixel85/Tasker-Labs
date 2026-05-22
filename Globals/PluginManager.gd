extends Node

const ID = "core.plugin_manager"
const trusted_developers = ["rosepen"]
signal ready_to_load

var _plugins = {}
var _developer_plugins = {}
var _loaded_plugins = []
var _loaded_plugin_scripts = {}

func _ready() -> void:
	if DirAccess.open("user://").dir_exists("plugins"):
		Debug.log("Located plugins directory",ID)
		ready_to_load.emit()
		return
	var files = DirAccess.open("user://")
	Debug.log("Plugins directory not found, creating now",ID)
	files.make_dir("plugins")
	ready_to_load.emit()

func get_plugin_name(plugin_id:String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["name"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["name"]
	return ERR_DOES_NOT_EXIST

func get_plugin_version(plugin_id:String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["version"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["version"]
	return ERR_DOES_NOT_EXIST

func get_plugin_author(plugin_id:String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["author"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["author"]
	return ERR_DOES_NOT_EXIST

func get_plugin_target_versions(plugin_id:String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["target_api_version"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["target_api_version"]
	return ERR_DOES_NOT_EXIST

func get_plugin_description(plugin_id:String):
	if !is_plugin_available(plugin_id):
		return ERR_DOES_NOT_EXIST

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())
		if plugin_info.has("description"):
			return plugin_info["description"]
		else:
			return ""
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())
		if plugin_info.has("description"):
			return plugin_info["description"]
		else:
			return ""
	return ERR_DOES_NOT_EXIST

func plugin_has_description(plugin_id:String):
	if !is_plugin_available(plugin_id):
		return false

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())
		return plugin_info.has("description")
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())
		return plugin_info.has("description")

func is_plugin_trusted(plugin_id:String):
	if trusted_developers.has(plugin_id.split(".")[1]):
		return true
	else:
		return false

func is_plugin_version_controlled(plugin_id:String):
	if !is_plugin_available(plugin_id):
		return false

	if _plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())
		return plugin_info.has("repo")
	elif _developer_plugins.has(plugin_id):
		var plugin_info = JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())
		return plugin_info.has("repo")

func scan_available_plugins():
	_plugins.clear()
	var dir = DirAccess.open("user://plugins")
	dir.list_dir_begin()
	var folder_name = dir.get_next()
	while folder_name != "":
		if dir.current_is_dir() and not folder_name.begins_with("."):
			var plugin_status = _verify_plugin(folder_name)
			if int(plugin_status) != ERR_INVALID_DATA:
				_plugins[plugin_status] = folder_name
				Debug.log("Found plugin: "+get_plugin_name(plugin_status),ID)
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
			var plugin_status = _verify_plugin(folder_name,"res://DeveloperPlugins/")
			if int(plugin_status) != ERR_INVALID_DATA:
				_developer_plugins[plugin_status] = folder_name
				Debug.log("Found developer plugin: "+get_plugin_name(plugin_status),ID)
		folder_name = dir.get_next()
	dir.list_dir_end()
	return OK

func _load_data():
	if Data.file_exists("PluginData"):
		var data = Data.load_file("PluginData")
		for plugin_id in data["loaded_plugins"]:
			load_plugin(plugin_id)
	else:
		Data.make_file("PluginData")
		save_data()

func _verify_plugin(plugin_name:String,file_path:String="user://plugins/"):
	if !FileAccess.file_exists(file_path+plugin_name+"/info.json"):
		Debug.log("Plugin "+plugin_name+" is missing info.json file, skipping...",ID)
		return
	#if !FileAccess.file_exists("user://plugins"+plugin_name+"plugin.pck"):
	#	Debug.log("Plugin "+plugin_name+" is missing plugin.pck file, skipping...",id)
	#	return

	var file = FileAccess.open(file_path+plugin_name+"/info.json",FileAccess.READ)
	var plugin_info:Dictionary = JSON.parse_string(file.get_as_text())

	if plugin_info == null:
		Debug.error("Plugin "+plugin_name+" has invalid info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info["target_api_versions"].has(Main.get_plugin_api_version()):
		Debug.error("Plugin "+plugin_name+" is not compatible with current version of Tasker's plugin API, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["name"] == null:
		Debug.error("Plugin "+plugin_name+" is missing name field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["version"] == null:
		Debug.error("Plugin "+plugin_name+" is missing version field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["author"] == null:
		Debug.error("Plugin "+plugin_name+" is missing author field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info.has("plugin_id"):
		Debug.error("Plugin "+plugin_name+" is missing plugin_id field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].begins_with("com."):
		Debug.error("Plugin "+plugin_name+" has invalid plugin_id field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].split(".").size() == 3:
		Debug.error("Plugin "+plugin_name+" has invalid plugin_id filed in info.json, skipping...",ID)
		return ERR_INVALID_DATA
	if _plugins.has(plugin_info["plugin_id"]):
		Debug.error("Plugin "+plugin_name+" has the same id as a previous plugin",ID)
		return ERR_INVALID_DATA
	return plugin_info["plugin_id"]

func load_plugin(plugin_id):
	if !get_all_plugins().has(plugin_id):
		Debug.error("Could't load plugin with id: "+plugin_id+", plugin not found",ID)
		return ERR_DOES_NOT_EXIST
	if _plugins.has(plugin_id):
		Debug.log("Loaded plugin: "+get_plugin_name(plugin_id),ID)
		save_data()
		return OK
	elif is_developer_plugin(plugin_id) and Settings.get_option_value("core.developer/dev_tools"):
		Debug.log("Loading developer plugin: "+get_plugin_name(plugin_id),ID)
		_loaded_plugin_scripts[plugin_id] = load("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/plugin.gd").new()
		if !_loaded_plugin_scripts[plugin_id].has_method("start") and _loaded_plugin_scripts[plugin_id].has_method("stop"):
			Debug.error("Plugin with id: "+plugin_id+" does not have required start and stop methods, didn't load",ID)
			return ERR_METHOD_NOT_FOUND
		_loaded_plugin_scripts[plugin_id].start()
		_loaded_plugins.append(plugin_id)
		save_data()
		return OK
	Debug.error("Could't load plugin with id: "+plugin_id+", because developer plugins are disabled",ID)
	return ERR_LOCKED

func unload_plugin(plugin_id:String):
	if !_loaded_plugins.has(plugin_id):
		Debug.error("Could't unload plugin with id: "+plugin_id+", plugin not found or not loaded",ID)
		return ERR_DOES_NOT_EXIST

	_loaded_plugins.erase(plugin_id)
	_loaded_plugin_scripts[plugin_id].stop()
	_loaded_plugin_scripts.erase(plugin_id)
	Debug.log("Unloaded plugin: "+get_plugin_name(plugin_id),ID)
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
	Data.save_to("loaded_plugins",_loaded_plugins, "PluginData")
	Data.save_file("PluginData")
