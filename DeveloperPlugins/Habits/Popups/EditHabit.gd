extends Control

@onready var name_limit: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/NameLimit
@onready var name_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/NameField
@onready var goal_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/GoalField
@onready var goal_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/GoalDown
@onready var goal_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/GoalUp
@onready var error_text: RGText = $RGContainer/MarginContainer/VBoxContainer/CenterContainer/ErrorText
@onready var edit: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Edit

var goal:int = 1
var habit_to_edit:Habit

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		edit.press()
		get_viewport().set_input_as_handled()

signal habit_edited(new_habit:Habit)

func _on_goal_down_pressed() -> void:
	var step := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step = 5
	if goal - step < 1:
		return
	goal -= step
	goal_field.set_text(str(goal)+"d")
	if goal == 1:
		goal_down.disabled = true

func _on_goal_up_pressed() -> void:
	goal_down.disabled = false
	var step := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step = 5
	goal += step
	goal_field.set_text(str(goal)+"d")

func _ready() -> void:
	edit.set_color(Settings.get_option_value("core.appearance/accent_color"))

func setup(habit:Habit):
	name_field.set_text(habit.display_name)
	goal = habit.goal
	if goal == 1:
		goal_down.set_disabled(true)
	goal_field.set_text(str(goal)+"d")
	name_field.edit()
	habit_to_edit = habit

func _on_cancel_pressed() -> void:
	Popups.clear_popup()

func _on_edit_pressed() -> void:
	if name_is_empty():
		error_text.set_text("Name can't be empty")
		error_text.show()
		return
	if name_field.get_text().length() > 24:
		error_text.set_text("Name must be less then 25 characters")
		error_text.show()
		name_limit.set_text("("+str(name_field.get_text().length())+"/24)")
		name_limit.show()
		return
	habit_to_edit.set_display_name(name_field.get_text())
	habit_to_edit.set_goal(goal)
	habit_edited.emit(habit_to_edit)
	Popups.clear_popup()

func name_is_empty():
	if name_field.get_text() == "":
		return true
	for character in name_field.get_text().split(""):
		if character != " ":
			return false
	return true

func _on_name_field_text_changed(_new_text: String) -> void:
	name_limit.set_text("("+str(name_field.get_text().length())+"/24)")
	if name_field.get_text().length() <= 24:
		name_limit.hide()
		error_text.hide()
