extends Node

class_name RGmenu

var elements:Array

func add_action(title:String,icon:Texture2D,action:Callable,action_params:Array=[],destructive:bool=false):
	var type
	match destructive:
		true:
			type = "destructive"
		false:
			type = "action"

	elements.append([
		type,
		title,
		icon,
		action,
		action_params
	])
	return OK

func add_menu(title:String,icon:Texture2D,menu:RGmenu):
	elements.append([
		"menu",
		title,
		icon,
		menu
	])

func add_seperator():
	elements.append([
		"seperator"
	])
func _init() -> void:
	elements = []
