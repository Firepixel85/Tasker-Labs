extends Control
@onready var progress_bar: RGProgressBar = $RGContainer/Content/VBoxContainer/Control/ProgressBar
@onready var progress_text: RGText = $RGContainer/Content/VBoxContainer/Control/MarginContainer/ProgressText
@onready var pause_unpause: RGButton = $RGContainer/Content/VBoxContainer/HBoxContainer/PauseUnpause
@onready var start_stop: RGButton = $RGContainer/Content/VBoxContainer/HBoxContainer/StartStop
@onready var content: MarginContainer = $RGContainer/Content
@onready var celebration: CenterContainer = $RGContainer/Celebration

var session:FocusSession
const ID = "com.rosepen.focus_core"

func setup(new_session:FocusSession):
	session = new_session
	progress_bar.set_color(session.get_project().get_color())
	session.get_project().info_updated.connect(_update_colors)
	session.project_attached.connect(_project_attached)
	session.time_updated.connect(_update_time)

func _update_colors():
	progress_bar.set_color(session.get_project().get_color())
	if session.is_running() and start_stop.is_hovered():
		start_stop.set_color(session.get_project().get_color())
	else:
		pause_unpause.set_color(session.get_project().get_color())
	if pause_unpause.is_hovered():
		pause_unpause.set_color(session.get_project().get_color())

func _project_attached():
	progress_bar.set_color(session.get_project().get_color())

func _on_pause_unpause_hovered() -> void:
	pause_unpause.set_color(session.get_project().get_color())

func _on_pause_unpause_de_hovered() -> void:
	if session.is_running():
		pause_unpause.set_color("Gray")
	else:
		pause_unpause.set_color(session.get_project().get_color())

func _on_start_stop_de_hovered() -> void:
	start_stop.set_color("Gray")

func _on_start_stop_hovered() -> void:
	start_stop.set_color(session.get_project().get_color())

func _on_start_stop_pressed() -> void:
	Sidebar.get_tab(ID)._on_start_stop_session_pressed()

func _on_pause_unpause_pressed() -> void:
	Sidebar.get_tab(ID)._pause_unpause_pressed()

func session_paused():
	pause_unpause.set_text("Resume")
	pause_unpause.set_color(session.get_project().get_color())

func session_unpaused():
	pause_unpause.set_text("Pause")
	if pause_unpause.is_hovered():
		pause_unpause.set_color(session.get_project().get_color())
	else:
		pause_unpause.set_color("Gray")

func end_session():
	celebration.show()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(content,"modulate",Color(1,1,1,0),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(celebration,"modulate",Color(1,1,1,1),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await get_tree().create_timer(4).timeout
	var tween2 = create_tween()
	tween2.tween_property(self,"modulate",Color(1,1,1,0),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween2.finished
	EventManager.remove_event(ID)

func _update_time(new_time:int):
	var hours = new_time / 3600
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
		progress_text.set_text(minutes_str + ":" + seconds_str)
	else:
		progress_text.set_text(hours_str+ ":" + minutes_str + ":" + seconds_str)
	var progress = 100*new_time/session.get_project().daily_goal
	progress_bar.tween_value(progress,0.2,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
