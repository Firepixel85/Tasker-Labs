extends Control
@onready var name_display: RGText = $HBoxContainer/HBoxContainer/Name
@onready var folder_display: RGText = $HBoxContainer/HBoxContainer2/Folder

var file:String
var file_name:String
var file_folder:String

signal open(file_to_open:String)

func setup(new_file:String):
	file = new_file
	if file.split("/").size() == 2:
		file_name = file.split("/")[1].rstrip(".json")
		name_display.set_text(file_name)
		file_folder = file.split("/")[0]
		folder_display.set_text(file_folder)
	else:
		file_name = file.rstrip(".json")
		name_display.set_text(file_name)
		file_folder = "Root"
		folder_display.set_text(file_folder)


func _on_open_pressed() -> void:
	open.emit(file)
