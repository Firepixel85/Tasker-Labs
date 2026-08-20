extends Control

@onready var name_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/NameContainer/NameField
@onready var color_menu: RGDropDown = $RGContainer/MarginContainer/VBoxContainer/ColorContainer/ColorMenu
@onready var edit: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Edit
@onready var error_message: RGText = $RGContainer/MarginContainer/VBoxContainer/ErrorMessage

@onready var goal_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/GoalContainer/HBoxContainer2/GoalField
@onready var goal_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/GoalContainer/HBoxContainer2/HBoxContainer/GoalDown
@onready var goal_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/GoalContainer/HBoxContainer2/HBoxContainer/GoalUp

@onready var daily_goal_field_hrs: RGTextField = $RGContainer/MarginContainer/VBoxContainer/DailyGoalContainer/HBoxContainer2/DailyGoalHrs
@onready var daily_goal_hrs_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/DailyGoalContainer/HBoxContainer2/HBoxContainer/DailyGoalHrsDown
@onready var daily_goal_hrs_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/DailyGoalContainer/HBoxContainer2/HBoxContainer/DailyGoalHrsUp

@onready var daily_goal_field_min: RGTextField = $RGContainer/MarginContainer/VBoxContainer/DailyGoalContainer/HBoxContainer2/DailyGoalMin
@onready var daily_goal_min_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/DailyGoalContainer/HBoxContainer2/HBoxContainer2/DailyGoalMinDown
@onready var daily_goal_min_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/DailyGoalContainer/HBoxContainer2/HBoxContainer2/DailyGoalMinUp

var goal:int = 10
var daily_goal_hrs:int = 1
var daily_goal_min:int = 30
var project:FocusProject

var color_dic := {
	"Yellow":0,
	"Orange":1,
	"Green":2,
	"Teal":3,
	"Blue":4,
	"Pink":5,
	"Purple":6
}

func _ready() -> void:
	edit.set_color(Settings.get_option_value("core.appearance/accent_color"))
	color_menu.add_item("Yellow",0)
	color_menu.add_item("Orange",1)
	color_menu.add_item("Green",2)
	color_menu.add_item("Teal",3)
	color_menu.add_item("Blue",4)
	color_menu.add_item("Pink",5)
	color_menu.add_item("Purple",6)
	color_menu.select(6)
	color_menu.canvas_layer_index = 3
	_update_values()
	name_field.edit()

func setup(new_project:FocusProject):
	project = new_project
	name_field.set_text(project.display_name)
	color_menu.select(color_dic[project.color])
	@warning_ignore("integer_division")
	goal = project.goal/3600
	@warning_ignore("integer_division")
	daily_goal_hrs = floor(project.daily_goal/3600)
	@warning_ignore("integer_division")
	daily_goal_min = (project.daily_goal%3600)/60
	_update_values()

func _update_values():
	goal_field.set_text(str(goal)+"h")
	daily_goal_field_hrs.set_text(str(daily_goal_hrs)+"h")
	daily_goal_field_min.set_text(str(daily_goal_min)+"m")

func _on_goal_down_pressed() -> void:
	goal_up.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if goal - step_value < 1:
		return
	goal -= step_value
	if goal == 1:
		goal_down.disabled = true
	_update_values()

func _on_goal_up_pressed() -> void:
	goal_down.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if goal + step_value > 100:
		return
	goal += step_value
	if goal == 100:
		goal_up.disabled = true
	_update_values()


func _on_daily_goal_hrs_down_pressed() -> void:
	daily_goal_hrs_up.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if daily_goal_min == 0:
		if daily_goal_hrs - step_value < 1:
			return
	else:
		if daily_goal_hrs - step_value < 0:
			return
	daily_goal_hrs -= step_value
	if daily_goal_min == 0:
		if daily_goal_hrs == 1:
			daily_goal_hrs_down.disabled = true
	else:
		if daily_goal_hrs == 0:
			daily_goal_hrs_down.disabled = true
	if daily_goal_min == 5:
		daily_goal_min_down.disabled = true
	_update_values()


func _on_daily_goal_hrs_up_pressed() -> void:
	daily_goal_hrs_down.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if daily_goal_hrs + step_value > 23:
		return
	daily_goal_hrs += step_value
	if daily_goal_hrs == 23:
		daily_goal_hrs_up.disabled = true
	if daily_goal_min == 5 and daily_goal_hrs == 1:
		daily_goal_min_down.disabled = false
	_update_values()

func _on_daily_goal_min_down_pressed() -> void:
	daily_goal_min_up.disabled = false
	var step_value := 5
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 10
	if daily_goal_hrs == 0:
		if daily_goal_min - step_value < 5:
			return
	else:
		if daily_goal_min - step_value < 0:
			return
	daily_goal_min -= step_value
	if daily_goal_hrs == 0:
		if daily_goal_min == 5:
			daily_goal_min_down.disabled = true
	else:
		if daily_goal_min == 0:
			daily_goal_min_down.disabled = true
	if daily_goal_hrs == 1 and daily_goal_min == 0:
		daily_goal_hrs_down.disabled = true
	_update_values()

func _on_daily_goal_min_up_pressed() -> void:
	daily_goal_min_down.disabled = false
	var step_value := 5
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 10
	if daily_goal_min + step_value > 55:
		return
	daily_goal_min += step_value
	if daily_goal_min == 55:
		daily_goal_min_up.disabled = true
	if daily_goal_hrs == 1:
		daily_goal_hrs_down.disabled = false
	_update_values()

func _on_edit_pressed() -> void:
	if name_is_empty():
		show_error_message("Name field can't be empty")
		name_field.incorrect = true
		name_field.edit()
		return
	elif name_field.get_text().split("").size() > 16:
		show_error_message("Name is to long, it must be less than 17 characters")
		name_field.incorrect = true
		name_field.edit()
		return
	if Sidebar.get_tab("com.rosepen.focus").projects.has(name_field.get_text()) and name_field.get_text() != project.display_name:
		show_error_message("A project with that name already exists")
		name_field.incorrect = true
		name_field.edit()
		return
	if project.display_name != name_field.get_text():
		Sidebar.get_tab("com.rosepen.focus").projects[name_field.get_text()] = project
		Sidebar.get_tab("com.rosepen.focus").project_ids[name_field.get_text()] = Sidebar.get_tab("com.rosepen.focus").project_ids[project.display_name]
		Sidebar.get_tab("com.rosepen.focus").projects.erase(project.display_name)
		Sidebar.get_tab("com.rosepen.focus").project_ids.erase(project.display_name)
		Sidebar.get_tab("com.rosepen.focus").project_select.rename_item(Sidebar.get_tab("com.rosepen.focus").project_ids[name_field.get_text()],name_field.get_text())
		Sidebar.get_tab("com.rosepen.focus").project_selector.rename_item(Sidebar.get_tab("com.rosepen.focus").project_ids[name_field.get_text()],name_field.get_text())
	project.display_name = name_field.get_text()
	project.color = color_menu.get_selected_item()
	project.goal = goal*3600
	project.daily_goal = daily_goal_hrs*3600 + daily_goal_min*60
	Popups.clear_popup()

func show_error_message(message:String):
	error_message.modulate = Color(1,1,1,1)
	error_message.set_text(message)

func _on_cancel_pressed() -> void:
	Popups.clear_popup()

func name_is_empty():
	if name_field.get_text() == "":
		return true
	for character in name_field.get_text().split(""):
		if character != " ":
			return false
	return true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		edit.press()

func _on_name_field_text_changed(_new_text: String) -> void:
	error_message.modulate = Color(1,1,1,0)
	name_field.incorrect = false
