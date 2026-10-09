extends Node
class_name FocusProject

var color:String:
	set(new_value):
		if RoseGarden.Colors.verify_color(new_value) == OK:
			color = new_value
			save(true)
			info_updated.emit()
var daily_goal:int:
	set(new_value):
		if new_value < 0:
			return
		daily_goal = new_value
		save(true)
		info_updated.emit()
var goal:int:
	set(new_value):
		if new_value < 0:
			return
		goal = new_value
		save(true)
		info_updated.emit()
var main:bool = false
var display_name:String:
	set(new_value):
		display_name = new_value
		save(true)
		info_updated.emit()

var tracked_time:int = 0
var tracked_time_today:int = 0
var handle:String

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

func add_time(time:int,save_data:bool = false):
	if time < 0:
		return
	tracked_time += time
	tracked_time_today += time
	tracked_time_updated.emit()
	if save_data:
		save()

func remove_time(time:int):
	if time < 0:
		return
	tracked_time -= time
	tracked_time_today -= time
	tracked_time_updated.emit()
	save()

func delete():
	Data.remove_file("com.rosepen.focus_core/"+handle)
	deleted.emit(self)

func save(all_data:bool = false):
	if handle == "":
		return
	Data.save_to("tracked_time",tracked_time,"com.rosepen.focus_core/"+handle)
	Data.save_to("tracked_time_today",tracked_time_today,"com.rosepen.focus_core/"+handle)
	if all_data:
		Data.save_to("display_name",display_name,"com.rosepen.focus_core/"+handle)
		Data.save_to("color",color,"com.rosepen.focus_core/"+handle)
		Data.save_to("daily_goal",daily_goal,"com.rosepen.focus_core/"+handle)
		Data.save_to("goal",goal,"com.rosepen.focus_core/"+handle)
	Data.save_file("com.rosepen.focus_core/"+handle)

func _ready() -> void:
	handle = "Project_"+str(int(Sidebar.get_tab("com.rosepen.focus_core").get_project_uid(display_name)))
	if !Data.file_exists("com.rosepen.focus_core/"+handle):
		Data.make_file(handle,"com.rosepen.focus_core")
	save(true)

func setup(data:Dictionary):
	if data.has("tracked_time"):
		tracked_time = data["tracked_time"]
	if data.has("tracked_time_today"):
		tracked_time_today = data["tracked_time_today"]
	if data.has("display_name"):
		display_name = data["display_name"]
	if data.has("color"):
		set_color(data["color"])
	if data.has("daily_goal"):
		daily_goal = data["daily_goal"]
	if data.has("goal"):
		goal = data["goal"]
	return OK
