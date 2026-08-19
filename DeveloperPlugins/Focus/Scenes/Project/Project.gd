extends Node
class_name FocusProject

var color:String:
	set(new_value):
		if RoseGarden.Colors.verify_color(new_value) == OK:
			color = new_value
			info_updated.emit()
var daily_goal:int:
	set(new_value):
		if new_value < 0:
			return
		daily_goal = new_value
		info_updated.emit()
var goal:int:
	set(new_value):
		if new_value < 0:
			return
		goal = new_value
		info_updated.emit()
var main:bool = false
var display_name:String:
	set(new_value):
		display_name = new_value
		info_updated.emit()

var tracked_time:int = 0
var tracked_time_today:int = 0

signal info_updated
signal tracked_time_updated(new_time:int)
signal deleted(project:FocusProject)

func set_color(new_color:String):
	if !RoseGarden.Colors.verify_color(new_color) == OK:
		return ERR_INVALID_PARAMETER
	color = new_color
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

func add_time(time:int):
	if time < 0:
		return
	tracked_time += time
	tracked_time_today += time
	tracked_time_updated.emit()

func remove_time(time:int):
	if time < 0:
		return
	tracked_time -= time
	tracked_time_today -= time
	tracked_time_updated.emit()

func delete():
	deleted.emit(self)
