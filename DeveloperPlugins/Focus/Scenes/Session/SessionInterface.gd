extends Control
@onready var progress_bar: RGProgressBar = $RGContainer/MarginContainer/HBoxContainer/VBoxContainer/RGProgressBar
@onready var project_tag: RGTag = $RGContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Project
@onready var display_name: RGText = $RGContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var time_text: RGText = $RGContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/Time
@onready var pause_icon: TextureRect = $RGContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/HBoxContainer/PauseIcon
@onready var controls_container: VBoxContainer = $RGContainer/MarginContainer/HBoxContainer/ControlsContainer


var session:FocusSession
var color:String

func setup(new_session:FocusSession):
	session = new_session
	session.get_project().info_updated.connect(_update)
	session.info_updated.connect(_update)
	session.time_updated.connect(_update_time)
	session.stopped.connect(_session_stopped)
	session.started.connect(_session_started)
	session.tracked.connect(_session_tracked)
	session.project_attached.connect(_update)
	_update()

func _update():
	color = session.get_project().get_color()
	project_tag.set_color(color)
	project_tag.set_text(session.get_project().display_name)
	progress_bar.set_color(color)
	display_name.text = session.display_name
	if session.get_project().is_main():
		project_tag.hide()

func _update_time(new_time:int):
	@warning_ignore("integer_division")
	var hours = new_time / 3600
	@warning_ignore("integer_division")
	var minutes = (new_time % 3600) / 60
	var seconds = new_time % 60
	var hours_str:String
	var minutes_str:String
	var seconds_str:String
	if hours < 10:
		hours_str = "0" + str(hours)
	else:
		hours_str = str(hours)
	if minutes < 10:
		minutes_str = "0" + str(minutes)
	else:
		minutes_str = str(minutes)
	if seconds < 10:
		seconds_str = "0" + str(seconds)
	else:
		seconds_str = str(seconds)

	if hours == 0:
		time_text.set_text("Focused for " + minutes_str + ":" + seconds_str)
	else:
		time_text.set_text("Focused for " + hours_str+ ":" + minutes_str + ":" + seconds_str)
	time_text._update()
	@warning_ignore("integer_division")
	progress_bar.tween_value(100*new_time/session.get_project().daily_goal,0.2,Tween.TRANS_SINE,Tween.EASE_IN_OUT)

func _session_started():
	pause_icon.hide()

func _session_stopped():
	pause_icon.show()

func _session_tracked():
	pause_icon.hide()
	controls_container.show()
