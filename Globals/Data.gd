extends Node

const ID = "core.data"

var all_data = {}
var actual_file_path = {}

var _ready_to_load: bool = false


func make_file(file_name: String, exclusive_folder := ""):
	var directory = DirAccess.open("user://")
	if !directory.dir_exists(exclusive_folder):
		directory.make_dir(exclusive_folder)
	if exclusive_folder == "":
		if FileAccess.file_exists("user://" + file_name + ".json"):
			Debug.warn(
				(
					"A process attempted to create a file with name: "
					+ file_name
					+ " but it already exists"
				),
				ID
			)
			return ERR_ALREADY_EXISTS
		var file = FileAccess.open("user://" + file_name + ".json", FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
		all_data[file_name] = {}
		actual_file_path[file_name] = "user://" + file_name + ".json"
		_save()
		if file_name != "Data":
			Debug.log("File created: " + file_name, ID)
		return OK
	else:
		if FileAccess.file_exists("user://" + exclusive_folder + "/" + file_name + ".json"):
			Debug.warn(
				(
					"A process attempted to create a file with name: "
					+ file_name
					+ " in folder: "
					+ exclusive_folder
					+ " but it already exists"
				),
				ID
			)
			return ERR_ALREADY_EXISTS
		var file = FileAccess.open(
			"user://" + exclusive_folder + "/" + file_name + ".json", FileAccess.WRITE
		)
		file.store_string(JSON.stringify({}))
		file.close()
		all_data[exclusive_folder + "/" + file_name] = {}
		actual_file_path[exclusive_folder + "/" + file_name] = (
			"user://" + exclusive_folder + "/" + file_name + ".json"
		)
		_save()
		Debug.log("Exclusive file created: " + exclusive_folder + "/" + file_name, ID)
		return OK


func save_to(data_name: String, data_value, file_name: String):
	if !FileAccess.file_exists(actual_file_path[file_name]):
		Debug.warn(
			"A process attempted to save data to a file that does not exist: " + file_name, ID
		)
		return ERR_FILE_NOT_FOUND
	all_data[file_name][data_name] = data_value


func save_file(file_name: String, silent = false):
	if !FileAccess.file_exists(actual_file_path[file_name]):
		Debug.warn("A process attempted to save a file that does not exist: " + file_name, ID)
		return ERR_FILE_NOT_FOUND
	var file = FileAccess.open(actual_file_path[file_name], FileAccess.WRITE)
	file.store_string(JSON.stringify(all_data[file_name]))
	file.close()
	if !silent:
		Debug.log("File saved: " + file_name, ID)


func load_file(file_name: String):
	if !FileAccess.file_exists(actual_file_path[file_name]):
		Debug.warn("A process attempted to load a file that does not exist: " + file_name, ID)
		return ERR_FILE_NOT_FOUND
	var file = FileAccess.open(actual_file_path[file_name], FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	all_data[file_name] = data
	Debug.log("File loaded: " + file_name, ID)
	return data


func file_exists(file_name):
	if actual_file_path.has(file_name):
		return FileAccess.file_exists(actual_file_path[file_name])
	return false


func _ready() -> void:
	if FileAccess.file_exists("user://Core/Data.json"):
		var data = JSON.parse_string(
			FileAccess.open("user://Core/Data.json", FileAccess.READ).get_as_text()
		)
		actual_file_path = data["actual_file_path"]
		all_data["Core/Data"] = data
	else:
		var file = FileAccess.open("user://Core/Data.json", FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
		all_data["Core/Data"] = {}
		actual_file_path["Core/Data"] = "user://Core/Data.json"
	await _save()
	Debug.log("Ready to load", ID)
	_ready_to_load = true


func _save():
	save_to("actual_file_path", actual_file_path, "Core/Data")
	save_file("Core/Data")
	return OK


func remove_file(file_name: String):
	var dir = DirAccess.open("user://")
	if dir == null:
		return ERR_CANT_OPEN
	var delete_err = dir.remove(actual_file_path[file_name].split("user://")[1])
	return delete_err
