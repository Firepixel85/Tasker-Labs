extends Node
class_name FocusProject

var color:String:
	set(new_value):
		if RoseGarden.Colors.verify_color(new_value) == OK:
			color = new_value
			info_updated.emit()
var daily_goal:int
var goal:int
var main:bool = false

signal info_updated

func set_color(new_color:String):
	if !RoseGarden.Colors.verify_color(new_color) == OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	info_updated.emit()
	return OK

func set_as_main():
	main = true

func is_main() -> bool:
	return main

func get_color() -> String:
	return color

func init():
	color = "Purple"
	daily_goal = 0
	goal = 0
