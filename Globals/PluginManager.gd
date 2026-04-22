extends Node

const id = "core.plugin_manager"
signal ready_to_load

var _plugins = {}

func _ready() -> void:
	if DirAccess.open("user://").dir_exists("plugins"):
		Debug.log("Located plugins directory",id)
		ready_to_load.emit()
		return
	var files = DirAccess.open("user://")
	Debug.log("Plugins directory not found, creating now",id)
	files.make_dir("plugins")
	ready_to_load.emit()

func get_plugin_name(plugin_id:String):
	if _plugins.has(plugin_id):
		return JSON.parse_string(FileAccess.open("user://plugins/"+_plugins[plugin_id]+"/info.json",FileAccess.READ).get_as_text())["name"]
	return "Unknown"

func scan_available_plugins():
	_plugins.clear()
	var dir = DirAccess.open("user://plugins")
	dir.list_dir_begin()
	var folder_name = dir.get_next()
	while folder_name != "":
		if dir.current_is_dir() and not folder_name.begins_with("."):
			var plugin_status = _verify_plugin(folder_name)
			if int(plugin_status) != ERR_INVALID_DATA and !_plugins.has(plugin_status):
				_plugins[plugin_status] = folder_name
				Debug.log("Found plugin: "+folder_name,id)
			elif _plugins.has(plugin_status):
				Debug.log("Plugin "+folder_name+" has a duplicate plugin_id",id)
		folder_name = dir.get_next()
	dir.list_dir_end()
	print(Main.get_process_name("com.rosepen.test"))
	return OK

func _verify_plugin(plugin_name:String):
	if !FileAccess.file_exists("user://plugins/"+plugin_name+"/info.json"):
		Debug.log("Plugin "+plugin_name+" is missing info.json file, skipping...",id)
		return
	#if !FileAccess.file_exists("user://plugins"+plugin_name+"plugin.pck"):
	#	Debug.log("Plugin "+plugin_name+" is missing plugin.pck file, skipping...",id)
	#	return

	var file = FileAccess.open("user://plugins/"+plugin_name+"/info.json",FileAccess.READ)
	var plugin_info:Dictionary = JSON.parse_string(file.get_as_text())

	if plugin_info == null:
		Debug.log("Plugin "+plugin_name+" has invalid info.json file, skipping...",id)
		return ERR_INVALID_DATA
	if plugin_info["target_version"] != Main.get_version():
		Debug.log("Plugin "+plugin_name+" is not compatible with current version of Tasker, skipping...",id)
		return ERR_INVALID_DATA
	if plugin_info["name"] == null:
		Debug.log("Plugin "+plugin_name+" is missing name field in info.json file, skipping...",id)
		return ERR_INVALID_DATA
	if plugin_info["version"] == null:
		Debug.log("Plugin "+plugin_name+" is missing version field in info.json file, skipping...",id)
		return ERR_INVALID_DATA
	if plugin_info["author"] == null:
		Debug.log("Plugin "+plugin_name+" is missing author field in info.json file, skipping...",id)
		return ERR_INVALID_DATA
	if !plugin_info.has("plugin_id"):
		Debug.log("Plugin "+plugin_name+" is missing plugin_id field in info.json file, skipping...",id)
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].begins_with("com."):
		Debug.log("Plugin "+plugin_name+" has invalid plugin_id field in info.json file, skipping...",id)
		return ERR_INVALID_DATA
	if !plugin_info["plugin_id"].split(".").size() == 3:
		Debug.log("Plugin "+plugin_name+" has invalid plugin_id filed in info.json, skipping...",id)
		return ERR_INVALID_DATA
	return plugin_info["plugin_id"]
