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
@warning_ignore("unused_signal")
signal tracked

func attach_project(new_project:FocusProject):
	if project != null:
		return ERR_ALREADY_EXISTS
	project = new_project
	project.deleted.connect(_project_deleted)
	project_attached.emit()
	return OK

func change_project(new_project:FocusProject):
	if project == new_project:
		return ERR_ALREADY_EXISTS
	project.deleted.disconnect(_project_deleted)
	project.remove_time(tracked_time)
	project = new_project
	project.deleted.connect(_project_deleted)
	project.add_time(tracked_time)
	project_attached.emit()
	return OK

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
		project.add_time(1)
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

func _project_deleted(_project:FocusProject):
	change_project(Sidebar.get_tab("com.rosepen.focus").main_project)

func add_time(time:int):
	if time < 0:
		return ERR_INVALID_PARAMETER
	tracked_time += time
	project.add_time(time)
	Sidebar.get_tab("com.rosepen.focus").add_time(time)
	time_updated.emit(tracked_time)
	return OK

func remove_time(time:int):
	if time < 0:
		return ERR_INVALID_PARAMETER
	tracked_time -= time
	project.remove_time(time)
	Sidebar.get_tab("com.rosepen.focus").remove_time(time)
	time_updated.emit(tracked_time)
	return OK

func delete():
	project.remove_time(tracked_time)
	Sidebar.get_tab("com.rosepen.focus").remove_time(tracked_time)
