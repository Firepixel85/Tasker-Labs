extends Node

const ID = "core.data"

var all_data = {}

func make_file(file_name:String):
	if FileAccess.file_exists("user://"+file_name+".json"):
		Debug.error("File already exists",ID)
		return
	var file = FileAccess.open("user://"+file_name+".json",FileAccess.WRITE)
	file.store_string(JSON.stringify({}))
	file.close()
	all_data[file_name] = {}
	Debug.log("File created: "+file_name,ID)
	
func save_to(data_name:String,data_value,file_name:String):
	if FileAccess.file_exists("user://"+file_name+".json"):
		all_data[file_name][data_name] = data_value
	
func save_file(file_name:String,silent=false):
	if FileAccess.file_exists("user://"+file_name+".json"):
		var file = FileAccess.open("user://"+file_name+".json",FileAccess.WRITE)
		file.store_string(JSON.stringify(all_data[file_name]))
		file.close()
		if !silent:
			Debug.log("File saved: "+file_name,ID)
		
func load_file(file_name:String):
	if FileAccess.file_exists("user://"+file_name+".json"):
		var file = FileAccess.open("user://"+file_name+".json",FileAccess.READ)
		var data = JSON.parse_string(file.get_as_text())
		all_data[file_name] = data
		Debug.log("File loaded: "+file_name,ID)
		return data
		
func file_exists(file_name):
	return FileAccess.file_exists("user://"+file_name+".json")
