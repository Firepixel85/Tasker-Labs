extends Control

@onready var columb1: VBoxContainer = $MarginContainer/HBoxContainer/Columb1/VBoxContainer
@onready var columb2: VBoxContainer = $MarginContainer/HBoxContainer/Columb2/VBoxContainer
@onready var columb3: VBoxContainer = $MarginContainer/HBoxContainer/Columb3/VBoxContainer
@onready var period_selector: RGSegmentControl = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/ControlsContainer/MarginContainer/HBoxContainer/PeriodSelector
@onready var project_selector: RGDropDown = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/ControlsContainer/MarginContainer/HBoxContainer/ProjectSelector

#Total Time
@onready var tt_hours: Label = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/TotalTimeContainer/CenterContainer/HBoxContainer/VBoxContainer/Hours
@onready var tt_minutes: Label = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/TotalTimeContainer/CenterContainer/HBoxContainer/VBoxContainer2/Minutes
@onready var tt_seconds: Label = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/TotalTimeContainer/CenterContainer/HBoxContainer/VBoxContainer3/Seconds

#Session Controls
@onready var session_controls_container: Control = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainer
@onready var goal_progress: RGDonutGraph = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainer/CenterContainer/VBoxContainer/GoalProgress
@onready var start_stop_session: RGButton = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainer/CenterContainer/VBoxContainer/HBoxContainer/StartStopSession
@onready var pause_unpause_session: RGButton = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainer/CenterContainer/VBoxContainer/HBoxContainer/PauseUnpauseSession

#Session Constrols Small
@onready var session_controls_container_small: Control = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall
@onready var goal_progress_small: RGProgressBar = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/GoalProgress
@onready var pause_unpause_session_small: RGButton = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/PauseUnpauseSession
@onready var start_stop_session_small: RGButton = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/StartStopSession

@onready var session_columb: Control = %SessionColumb
@onready var project_columb: Control = %ProjectColumb

func _ready() -> void:
	get_tree().root.size_changed.connect(_resize_update)
	Settings.setting_changed.connect(_settings_update)
	_resize_update()
	goal_progress.set_color(Settings.get_option_value("core.appearance/accent_color"))
	goal_progress_small.set_color(Settings.get_option_value("core.appearance/accent_color"))
	start_stop_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))
	start_stop_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
	period_selector.add_item("day", " Day ")
	period_selector.add_item("week", " Week ")
	project_selector.add_item("All Projects", 0)
	session_columb.add_session()
	session_columb.add_session()
	session_columb.add_session()
	session_columb.add_session()

func _resize_update():
	if get_window().size.y < 1100:
		session_controls_container_small.show()
		session_controls_container.hide()
	else:
		session_controls_container_small.hide()
		session_controls_container.show()

	session_columb.custom_minimum_size.y = columb1.get_parent().get_parent().size.y
	project_columb.custom_minimum_size.y = columb1.get_parent().get_parent().size.y
	if get_window().size.x < 1642:
		columb2.get_parent().hide()
		columb3.get_parent().hide()
		session_controls_container_small.show()
		session_controls_container.hide()
		if session_columb.get_parent() != columb1:
			session_columb.reparent(columb1)
		if project_columb.get_parent() != columb1:
			project_columb.reparent(columb1)
	elif get_window().size.x < 2206:
		columb2.get_parent().show()
		columb3.get_parent().hide()
		if project_columb.get_parent() != columb2:
			project_columb.reparent(columb2)
		if session_columb.get_parent() != columb2:
			session_columb.reparent(columb2)
	else:
		columb2.get_parent().show()
		columb3.get_parent().show()
		if session_columb.get_parent() != columb3:
			session_columb.reparent(columb2)
			session_columb.custom_minimum_size.y = 0
		if project_columb.get_parent() != columb3:
			project_columb.reparent(columb3)
			project_columb.custom_minimum_size.y = 0



func _settings_update(option_path: String, new_value):
	if option_path == "core.appearance/accent_color":
		goal_progress.set_color(new_value)
		goal_progress_small.set_color(new_value)
		start_stop_session_small.set_color(new_value)
		start_stop_session.set_color(new_value)
