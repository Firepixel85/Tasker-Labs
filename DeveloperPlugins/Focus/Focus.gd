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
@onready var project_select: RGDropDown = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainer/CenterContainer/VBoxContainer/HBoxContainer/ProjectSelect

#Session Constrols Small
@onready var session_controls_container_small: Control = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall
@onready var goal_progress_small: RGProgressBar = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/GoalProgress
@onready var pause_unpause_session_small: RGButton = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/PauseUnpauseSession
@onready var start_stop_session_small: RGButton = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/StartStopSession
@onready var project_select_small: RGDropDown = $MarginContainer/HBoxContainer/Columb1/VBoxContainer/SessionControlsContainerSmall/MarginContainer/VBoxContainer/HBoxContainer/ProjectSelect

@onready var session_columb: Control = %SessionColumb
@onready var project_columb: Control = %ProjectColumb

var main_project:FocusProject

var current_session:FocusSession
var current_session_interface
var current_session_time:int = 0

var total_time:int = 0
var goal:float = 100.0

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

	project_select.add_item("None",0)
	project_select_small.add_item("None",0)
	project_select.add_item("Test",1)
	project_select_small.add_item("Test",1)

	main_project = FocusProject.new()
	main_project.set_as_main()
	main_project.set_color(Settings.get_option_value("core.appearance/accent_color"))
	main_project.daily_goal = goal

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

func _settings_update(option_path:String,new_value):
	if option_path == "core.appearance/accent_color":
		goal_progress.set_color(new_value)
		goal_progress_small.set_color(new_value)
		main_project.set_color(new_value)
		if current_session == null:
			start_stop_session_small.set_color(new_value)
			start_stop_session.set_color(new_value)

func _on_start_stop_session_pressed() -> void:
	RoseGarden.clear_tooltips()
	if current_session == null:
		current_session = FocusSession.new()
		current_session.attach_project(main_project)
		current_session.set_display_name("Session at %s"%Time.get_time_string_from_system().split(":")[0]+":"+Time.get_time_string_from_system().split(":")[1])
		current_session.time_updated.connect(_update_time)
		add_child(current_session)
		current_session_interface = session_columb.add_session_interface()
		current_session_interface.setup(current_session)
		start_stop_session.set_text("Done")
		start_stop_session_small.set_text("Done")
		start_stop_session.tooltip_display_text = "Stop session"
		start_stop_session_small.tooltip_display_text = "Stop session"
		pause_unpause_session.set_color("Gray")
		pause_unpause_session_small.set_color("Gray")
		project_select.hide()
		project_select_small.hide()
		pause_unpause_session.show()
		pause_unpause_session_small.show()
		current_session.start()
	else:
		current_session.stop()
		current_session.tracked.emit()
		current_session = null
		current_session_interface = null
		current_session_time = 0
		start_stop_session.set_text("Focus")
		start_stop_session_small.set_text("Focus")
		start_stop_session.tooltip_display_text = "Start session"
		start_stop_session_small.tooltip_display_text = "Start session"
		pause_unpause_session.set_text("Pause")
		pause_unpause_session_small.set_text("Pause")
		pause_unpause_session.hide()
		pause_unpause_session_small.hide()
		project_select.show()
		project_select_small.show()
		start_stop_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
		start_stop_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))

func _start_stop_hovered():
	if current_session == null:
		return
	start_stop_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
	start_stop_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))

func _start_stop_dehovered():
	if current_session == null:
		return
	start_stop_session.set_color("Gray")
	start_stop_session_small.set_color("Gray")

func _pause_unpause_hovered():
	pause_unpause_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
	pause_unpause_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))

func _pause_unpause_dehovered():
	if !current_session.is_running():
		return
	pause_unpause_session.set_color("Gray")
	pause_unpause_session_small.set_color("Gray")

func _pause_unpause_pressed():
	RoseGarden.clear_tooltips()
	if current_session.is_running():
		pause_unpause_session.set_text("Resume")
		pause_unpause_session_small.set_text("Resume")
		pause_unpause_session.tooltip_display_text = "Resume session"
		pause_unpause_session_small.tooltip_display_text = "Resume session"
		current_session.stop()
	else:
		pause_unpause_session.set_text("Pause")
		pause_unpause_session_small.set_text("Pause")
		pause_unpause_session.tooltip_display_text = "Pause session"
		pause_unpause_session_small.tooltip_display_text = "Pause session"
		current_session.start()

func _update_time(new_time):
	total_time += new_time - current_session_time
	current_session_time = new_time

	@warning_ignore("integer_division")
	var hours = total_time / 3600
	@warning_ignore("integer_division")
	var minutes = (total_time % 3600) / 60
	var seconds = total_time % 60
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

	tt_hours.text = hours_str
	tt_minutes.text = minutes_str
	tt_seconds.text = seconds_str
	goal_progress.tween_value(int(100*total_time/goal),0.2,0,Tween.TRANS_SINE,Tween.EASE_IN_OUT)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("focus_start_stop_session"):
		if session_controls_container.visible:
			start_stop_session.press()
		else:
			start_stop_session_small.press()
		if current_session == null:
			start_stop_session.set_color("Gray")
			start_stop_session_small.set_color("Gray")
		else:
			start_stop_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
			start_stop_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))
	if Input.is_action_just_pressed("focus_pause_unpause_session"):
		if current_session == null:
			return
		if session_controls_container.visible:
			pause_unpause_session.press()
		else:
			pause_unpause_session_small.press()
		if current_session.is_running():
			pause_unpause_session.set_color(Settings.get_option_value("core.appearance/accent_color"))
			pause_unpause_session_small.set_color(Settings.get_option_value("core.appearance/accent_color"))
		else:
			pause_unpause_session.set_color("Gray")
			pause_unpause_session_small.set_color("Gray")
	if Input.is_action_just_pressed("focus_create_project"):
		pass
