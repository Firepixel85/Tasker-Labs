extends Node

const ID = "core.settings"
var _settings_list = {}
var _settings_values = {}
var _category_names = {}
var _category_list = []
var _category_icons = {}

signal category_added(category_id)
signal option_added(option_id,category_id)
signal setting_changed(option_path,new_value)
signal settings_loaded

func load_settings():
	if Data.file_exists("SettingsData"):
		var data = Data.load_file("SettingsData")
		_settings_list = data["settings_list"]
		_settings_values = data["settings_values"]
		_category_names = data["category_names"]
		_category_list = data["category_list"]
		_category_icons = data["category_icons"]
	else:
		Data.make_file("SettingsData")
		save_settings()
	settings_loaded.emit()
	return OK

func save_settings():
	Data.save_to("settings_list",_settings_list,"SettingsData")
	Data.save_to("settings_values",_settings_values,"SettingsData")
	Data.save_to("category_names",_category_names,"SettingsData")
	Data.save_to("category_list",_category_list,"SettingsData")
	Data.save_to("category_icons",_category_icons,"SettingsData")
	Data.save_file("SettingsData")

# Category functions #

func add_category(display_name:String,icon_path:String,category_id:String):
	if _settings_list.has(category_id):
		Debug.error("Attempted to add category with id: "+category_id+" but it already exists",ID)
		return ERR_ALREADY_EXISTS

	_settings_list[category_id] = {}
	_settings_values[category_id] = {}
	_category_list.append(category_id)
	_category_names[category_id] = display_name
	_category_icons[category_id] = icon_path
	category_added.emit(category_id)
	Debug.log("Category added with id: "+category_id,ID)
	save_settings()
	return OK

func remove_category(category_id:String):
	if !_settings_list.has(category_id):
		Debug.error("Attempted to remove nonexistant category with id: "+category_id,ID)
		return ERR_DOES_NOT_EXIST

	_settings_list.erase(category_id)
	_settings_values.erase(category_id)
	_category_list.erase(category_id)
	_category_names.erase(category_id)
	_category_icons.erase(category_id)
	save_settings()
	Debug.log("Category removed with id: "+category_id,ID)
	return OK

func hide_category(category_id):
	if !_settings_list.has(category_id):
		Debug.error("Attempted to hide nonexistant category with id: "+category_id,ID)
		return ERR_DOES_NOT_EXIST

	Debug.log("Category hidden with id: "+category_id,ID)
	_category_list.erase(category_id)
	return OK

func show_category(category_id):
	if !_settings_list.has(category_id):
		Debug.error("Attempted to show nonexistant category with id: "+category_id,ID)
		return ERR_DOES_NOT_EXIST

	Debug.log("Category shown with id: "+category_id,ID)
	_category_list.append(category_id)
	return OK

func get_category(category_id:String):
	if !_settings_list.has(category_id):
		return ERR_DOES_NOT_EXIST

	return _settings_list[category_id]

func get_category_name(category_id:String):
	if !_settings_list.has(category_id):
		return ERR_DOES_NOT_EXIST

	return _category_names[category_id]

func get_category_icon(category_id:String):
	if !_settings_list.has(category_id):
		return ERR_DOES_NOT_EXIST

	return load(_category_icons[category_id])

func category_exists(category_id:String):
	return _settings_list.has(category_id)

# Option functions #

func add_option(category_id:String,option_id:String,option_scene_path:String,default_value):
	if !_settings_list.has(category_id):
		Debug.error("Attempted to add option to nonexistant category: "+category_id,ID)
		return ERR_DOES_NOT_EXIST
	if _settings_list[category_id].has(option_id):
		Debug.error("Attempted to add option with id: "+option_id+" to category: "+category_id+" but it already exists",ID)
		return ERR_ALREADY_EXISTS
	if !load(option_scene_path) is PackedScene:
		Debug.error("Attempted to add option with invalid scene path: "+option_scene_path,ID)
		return ERR_INVALID_PARAMETER
	var instance = load(option_scene_path).instantiate()
	if !instance.has_method("set_value"):
		Debug.error("Attempted to add option with scene path: "+option_scene_path+" but it does not have a set_value method",ID)
		return ERR_METHOD_NOT_FOUND
	if !instance.has_method("get_value"):
		Debug.error("Attempted to add option with scene path: "+option_scene_path+" but it does not have a get_value method",ID)
		return ERR_METHOD_NOT_FOUND

	_settings_list[category_id][option_id] = option_scene_path
	_settings_values[category_id][option_id] = default_value
	option_added.emit(option_id,category_id)
	Debug.log("Option added under path: "+category_id+"/"+option_id,ID)
	save_settings()
	return OK

func remove_option(option_path:String):
	if option_path.split("/").size() != 2:
		Debug.error("Attempted to remove option with invalid path: "+option_path,ID)
		return ERR_INVALID_PARAMETER
	var category_id = option_path.split("/")[0]
	var option_id = option_path.split("/")[1]
	if !_settings_list.has(category_id):
		Debug.error("Attempted to remove option from nonexistant category: "+category_id,ID)
		return ERR_DOES_NOT_EXIST
	if _settings_list[category_id].has(option_id):
		Debug.error("Attempted to remove nonexistant option with option path: "+option_path,ID)
		return ERR_DOES_NOT_EXIST

	_settings_list[category_id].erase(option_id)
	_settings_values[category_id].erase(option_id)
	save_settings()
	Debug.log("Option removed at path: "+option_path,ID)
	return OK

func get_option_value(option_path:String):
	if option_path.split("/").size() != 2:
		return ERR_INVALID_PARAMETER
	var category_id = option_path.split("/")[0]
	var option_id = option_path.split("/")[1]
	if !_settings_list.has(category_id):
		return ERR_DOES_NOT_EXIST
	if !_settings_list[category_id].has(option_id):
		return ERR_DOES_NOT_EXIST

	return _settings_values[category_id][option_id]

func set_option_value(option_path:String,new_value):
	if option_path.split("/").size() != 2:
		Debug.error("Attempted to set option value with invalid path: "+option_path,ID)
		return ERR_INVALID_PARAMETER
	var category_id = option_path.split("/")[0]
	var option_id = option_path.split("/")[1]
	if !_settings_list.has(category_id):
		Debug.error("Attempted to set option value for nonexistant category: "+category_id,ID)
		return ERR_DOES_NOT_EXIST
	if !_settings_list[category_id].has(option_id):
		Debug.error("Attempted to set option value for nonexistant option with path: "+option_path,ID)
		return ERR_DOES_NOT_EXIST

	_settings_values[category_id][option_id] = new_value
	Debug.log("Setting changed at path: "+option_path+" to value: "+str(new_value),ID)
	setting_changed.emit(option_path,new_value)
	save_settings()
	return OK

func option_exists(option_path:String):
	if option_path.split("/").size() != 2:
		return ERR_INVALID_PARAMETER
	var category_id = option_path.split("/")[0]
	var option_id = option_path.split("/")[1]
	if !_settings_list.has(category_id):
		return ERR_DOES_NOT_EXIST

	return _settings_list[category_id].has(option_id)
