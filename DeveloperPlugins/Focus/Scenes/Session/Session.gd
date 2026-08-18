extends Node
class_name FocusSession

var project:FocusProject
var tracked_time:int = 0
var running:bool = false
var display_name:String

signal project_attached(new_project:FocusProject)
signal started
signal stopped
signal time_updated(new_time:int)
signal info_updated
signal tracked

func attach_project(new_project:FocusProject):
	project = new_project
	project_attached.emit(project)

func get_project() -> FocusProject:
	return project

func start():
	running = true
	started.emit()
	while running:
		await get_tree().create_timer(1).timeout
		if !running:
			return
		tracked_time += 1
		time_updated.emit(tracked_time)

func stop():
	running = false
	stopped.emit()

func is_running() -> bool:
	return running

func init():
	info_updated.emit()

func set_display_name(new_name:String):
	display_name = new_name
	info_updated.emit()
