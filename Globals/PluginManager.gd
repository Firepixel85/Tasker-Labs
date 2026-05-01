extends Node

const ID = "core.plugin_manager"
signal ready_to_load

var _plugins = {}
var _developer_plugins = {}
var _loaded_plugins = []

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

func get_plugin_target_version(plugin_id:String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["target_version"]
	elif _developer_plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["target_version"]
	return ERR_DOES_NOT_EXIST

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
	if !Main.developerMode:
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
		Debug.log("Plugin "+plugin_name+" has invalid info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["target_version"] != Main.get_version():
		Debug.log("Plugin "+plugin_name+" is not compatible with current version of Tasker, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["name"] == null:
		Debug.log("Plugin "+plugin_name+" is missing name field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["version"] == null:
		Debug.log("Plugin "+plugin_name+" is missing version field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if plugin_info["author"] == null:
		Debug.log("Plugin "+plugin_name+" is missing author field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info.has("plugin_id"):
		Debug.log("Plugin "+plugin_name+" is missing plugin_id field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].begins_with("com."):
		Debug.log("Plugin "+plugin_name+" has invalid plugin_id field in info.json file, skipping...",ID)
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].split(".").size() == 3:
		Debug.log("Plugin "+plugin_name+" has invalid plugin_id filed in info.json, skipping...",ID)
		return ERR_INVALID_DATA
	if _plugins.has(plugin_info["plugin_id"]):
		Debug.log("Plugin "+plugin_name+" has the same id as a previous plugin",ID)
		return ERR_INVALID_DATA
	return plugin_info["plugin_id"]

func load_plugin(plugin_id):
	if _plugins.has(plugin_id):
		Debug.log("Loaded plugin: "+get_plugin_name(plugin_id),ID)
		return OK
	elif is_developer_plugin(plugin_id):
		Debug.log("Loading developer plugin: "+get_plugin_name(plugin_id),ID)
		load("res://DeveloperPlugins/"+_developer_plugins[plugin_id]+"/plugin.gd").new().start()
		_loaded_plugins.append(plugin_id)
		return OK
	else:
		return ERR_DOES_NOT_EXIST

func is_developer_plugin(plugin_id):
	if _developer_plugins.has(plugin_id):
		return true
	else:
		return false

func _start_load():#Called during startup
	pass
