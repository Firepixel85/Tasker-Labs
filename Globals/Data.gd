extends Node

const ID = "core.data"

var all_data = {}
var actual_file_path = {}

var _ready_to_load:bool = false

func make_file(file_name:String,exclusive_folder:=""):
	var directory = DirAccess.open("user://")
	if !directory.dir_exists(exclusive_folder):
		directory.make_dir(exclusive_folder)
	if exclusive_folder == "":
		if FileAccess.file_exists("user://"+file_name+".json"):
			return ERR_ALREADY_EXISTS
		var file = FileAccess.open("user://"+file_name+".json",FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
		all_data[file_name] = {}
		actual_file_path[file_name] = "user://"+file_name+".json"
		_save()
		if file_name != "Data":
			Debug.log("File created: "+file_name,ID)
		return OK
	else:
		if FileAccess.file_exists("user://"+exclusive_folder+"/"+file_name+".json"):
			return ERR_ALREADY_EXISTS
		var file = FileAccess.open("user://"+exclusive_folder+"/"+file_name+".json",FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
		all_data[file_name] = {}
		actual_file_path[file_name] = "user://"+exclusive_folder+"/"+file_name+".json"
		_save()
		Debug.log("Exclusive file created: "+exclusive_folder+"/"+file_name,ID)
		return OK

func save_to(data_name:String,data_value,file_name:String):
	if !FileAccess.file_exists(actual_file_path[file_name]):
		return ERR_FILE_NOT_FOUND
	all_data[file_name][data_name] = data_value

func save_file(file_name:String,silent=false):
	if !FileAccess.file_exists(actual_file_path[file_name]):
		return ERR_FILE_NOT_FOUND
	var file = FileAccess.open(actual_file_path[file_name],FileAccess.WRITE)
	file.store_string(JSON.stringify(all_data[file_name]))
	file.close()
	if !silent:
		Debug.log("File saved: "+file_name,ID)

func load_file(file_name:String):
	if !FileAccess.file_exists(actual_file_path[file_name]):
		return ERR_FILE_NOT_FOUND
	var file = FileAccess.open(actual_file_path[file_name],FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	all_data[file_name] = data
	Debug.log("File loaded: "+file_name,ID)
	return data

func file_exists(file_name):
	if actual_file_path.has(file_name):
		return FileAccess.file_exists(actual_file_path[file_name])
	return false


func _ready() -> void:
	if FileAccess.file_exists("user://Data.json"):
		var data = JSON.parse_string(FileAccess.open("user://Data.json",FileAccess.READ).get_as_text())
		actual_file_path = data["actual_file_path"]
		all_data["Data"] = data
	else:
		var file = FileAccess.open("user://Data.json",FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
		all_data["Data"] = {}
		actual_file_path["Data"] = "user://Data.json"
	await _save()
	Debug.log("Data is ready to load",ID)
	_ready_to_load = true

func _save():
	save_to("actual_file_path",actual_file_path,"Data")
	save_file("Data")
	return OK
