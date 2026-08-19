extends Control
@onready var goal_progress: RGProgressBar = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/GoalProgress
@onready var progress_text: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/HBoxContainer/ProgressText
@onready var title: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Title
@onready var goal_text: RichTextLabel = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/GoalText
@onready var mode_toggle: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/ModeToggle

var project:FocusProject
var mode:String = "daily":
	set(new_value):
		if new_value != "daily" and new_value != "goal":
			return
		mode = new_value

func setup(new_project:FocusProject):
	project = new_project
	title.text = project.display_name
	project.tracked_time_updated.connect(_update_tracked_time)
	project.info_updated.connect(_project_info_changed)
	goal_progress.set_color(project.color)
	_set_goal_text()

func _project_info_changed():
	title.text = project.display_name
	goal_progress.set_color(project.color)
	_set_goal_text()
	_update_tracked_time()

func _update_tracked_time():
	var hrs_str:String
	var min_str:String
	var sec_str:String
	if mode == "daily":
		@warning_ignore("integer_division")
		goal_progress.tween_value(int(project.tracked_time_today*100/project.daily_goal),0.2,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		@warning_ignore("integer_division")
		var hrs:int = floor(project.tracked_time_today/3600)
		@warning_ignore("integer_division", "shadowed_global_identifier")
		var min:int = floor((project.tracked_time_today%3600)/60)
		var sec:int = project.tracked_time_today%60

		hrs_str = str(hrs)
		min_str = str(min)
		sec_str = str(sec)

		if hrs < 10:
			hrs_str = "0" + hrs_str
		if min < 10:
			min_str = "0" + min_str
		if sec < 10:
			sec_str = "0" + sec_str
	else:
		@warning_ignore("integer_division")
		goal_progress.tween_value(int(project.tracked_time*100/project.goal),0.2,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		@warning_ignore("integer_division")
		var hrs:int = floor(project.tracked_time/3600)
		@warning_ignore("integer_division", "shadowed_global_identifier")
		var min:int = floor((project.tracked_time%3600)/60)
		var sec:int = project.tracked_time%60

		hrs_str = str(hrs)
		min_str = str(min)
		sec_str = str(sec)

		if hrs < 10:
			hrs_str = "0" + hrs_str
		if min < 10:
			min_str = "0" + min_str
		if sec < 10:
			sec_str = "0" + sec_str
	if hrs_str == "00":
		progress_text.tween_counter(min_str+":"+sec_str,0.2)
		progress_text.get_parent().custom_minimum_size.x = 60
	else:
		progress_text.tween_counter(hrs_str+":"+min_str+":"+sec_str,0.2)
		progress_text.get_parent().custom_minimum_size.x = 84


func _on_mode_toggle_pressed() -> void:
	if mode == "daily":
		mode = "goal"
		mode_toggle.icon = Icons.CALENDAR
		mode_toggle.tooltip_display_text = "Show daily goal"
	else:
		mode = "daily"
		mode_toggle.icon = Icons.CALENDARDOWNARROW
		mode_toggle.tooltip_display_text = "Show goal"
	_set_goal_text()
	_update_tracked_time()

func _set_goal_text():
	if mode == "daily":
		@warning_ignore("integer_division")
		var hrs = floor(project.daily_goal/3600)
		@warning_ignore("integer_division", "shadowed_global_identifier")
		var min = floor((project.daily_goal%3600)/60)
		if min == 0:
			goal_text.text = "[color=acacac]Daily goal: [color=f5f5f5] %sh"%hrs
		elif hrs == 0:
			goal_text.text = "[color=acacac]Daily goal: [color=f5f5f5] %sm"%min
		else:
			goal_text.text = "[color=acacac]Daily goal: [color=f5f5f5] %sh %dm"%[hrs,min]
	else:
		@warning_ignore("integer_division")
		var hrs = floor(project.goal/3600)
		goal_text.text = "[color=acacac]Goal: [color=f5f5f5] %sh"%hrs

func empty():
	pass

func _on_more_pressed() -> void:
	var menu = RGmenu.new()
	menu.add_action("Edit",Icons.PENCIL,edit)
	menu.add_action("Delete",Icons.TRASH,delete,[],true)
	RoseGarden.create_rc_menu(menu,get_global_mouse_position())
	
func delete():
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.DOUBLE_ACTION)
	popup.set_title("Are you sure?")
	popup.title_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.set_description("Deleting this project is a permanent action, that can not be undone. All sessions attached to this project will be detached.")
	popup.description_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.hide_close_button()
	popup.add_action(empty,"Cancel",[],"Gray")
	popup.add_action(delete_confirmed,"Delete",[],"Red")
	Popups.create_prefab_popup(popup)
	
func delete_confirmed():
	project.delete()
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	queue_free()

func edit():
	Popups.create_popup(load(PluginManager.get_plugin_filepath("com.rosepen.focus")+"Popups/EditProject.tscn"))
	await get_tree().process_frame
	Popups.get_popup().setup(project)
