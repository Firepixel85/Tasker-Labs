extends Control

@onready var columb1: VBoxContainer = $MarginContainer/HBoxContainer/Columb1
@onready var columb2: VBoxContainer = $MarginContainer/HBoxContainer/Columb2
@onready var columb3: VBoxContainer = $MarginContainer/HBoxContainer/Columb3
@onready var period_selector: RGSegmentControl = $MarginContainer/HBoxContainer/Columb1/ControlsContainer/MarginContainer/HBoxContainer/PeriodSelector
@onready var project_selector: RGDropDown = $MarginContainer/HBoxContainer/Columb1/ControlsContainer/MarginContainer/HBoxContainer/ProjectSelector

#Total Time
@onready var tt_hours: Label = $MarginContainer/HBoxContainer/Columb1/TotalTimeContainer/CenterContainer/HBoxContainer/VBoxContainer/Hours
@onready var tt_minutes: Label = $MarginContainer/HBoxContainer/Columb1/TotalTimeContainer/CenterContainer/HBoxContainer/VBoxContainer2/Minutes
@onready var tt_seconds: Label = $MarginContainer/HBoxContainer/Columb1/TotalTimeContainer/CenterContainer/HBoxContainer/VBoxContainer3/Seconds

#Session Controls
@onready var session_controls_container: Control = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainer
@onready var goal_progress: RGDonutGraph = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainer/CenterContainer/VBoxContainer/GoalProgress
@onready var start_stop_session: RGButton = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainer/CenterContainer/VBoxContainer/HBoxContainer/StartStopSession
@onready var pause_unpause_session: RGButton = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainer/CenterContainer/VBoxContainer/HBoxContainer/PauseUnpauseSession

#Session Constrols Small
@onready var session_controls_container_small: Control = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainerSmall
@onready var goal_progress_small: RGProgressBar = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainerSmall/MarginContainer/VBoxContainer/GoalProgress
@onready var pause_unpause_session_small: RGButton = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/PauseUnpauseSession
@onready var start_stop_session_small: RGButton = $MarginContainer/HBoxContainer/Columb1/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/StartStopSession

func _ready() -> void:
	get_tree().root.size_changed.connect(_resize_update)
	Settings.setting_changed.connect(_settings_update)
	_resize_update()
	goal_progress.set_color(Settings.get_option_value("core.appearance/accent_color"))
	goal_progress_small.set_color(Settings.get_option_value("core.appearance/accent_color"))
	start_stop_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))
	start_stop_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
	period_selector.add_item("day"," Day ")
	period_selector.add_item("week"," Week ")
	project_selector.add_item("All Projects",0)
	
func _resize_update():
	if get_window().size.y < 1100:
		session_controls_container_small.show()
		session_controls_container.hide()
	else:
		session_controls_container_small.hide()
		session_controls_container.show()
	
	if get_window().size.x < 2206:
		columb3.hide()
	else:
		columb3.show()
	
	if get_window().size.x < 1642:
		columb2.hide()
	else:
		columb2.show()
	
func _settings_update(option_path:String,new_value):
	if option_path == "core.appearance/accent_color":
		goal_progress.set_color(new_value)
		goal_progress_small.set_color(new_value)
		start_stop_session_small.set_color(new_value)
		start_stop_session.set_color(new_value)
