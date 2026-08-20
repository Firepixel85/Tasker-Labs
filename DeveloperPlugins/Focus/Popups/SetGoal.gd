extends Control

@onready var hrs_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Hrs/Hours/HrsField
@onready var hrs_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Hrs/Hours2/HrsDown
@onready var hrs_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Hrs/Hours2/HrsUp

@onready var min_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Min/HBoxContainer/MinField
@onready var min_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Min/HBoxContainer2/MinDown
@onready var min_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Min/HBoxContainer2/MinUp

@onready var set_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Set

var goal_hrs:int = 0
var goal_min:int = 0

func setup(goal:int):
	set_button.set_color(Settings.get_option_value("core.appearance/accent_color"))
	@warning_ignore("integer_division")
	goal_hrs = goal / 3600
	@warning_ignore("integer_division")
	goal_min = (goal % 3600) / 60
	_update_values()

func _update_values():
	hrs_field.set_text(str(goal_hrs)+"h")
	min_field.set_text(str(goal_min)+"m")

func _on_hrs_down_pressed() -> void:
	hrs_up.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if goal_min == 0:
		if goal_hrs - step_value < 1:
			return
	else:
		if goal_hrs - step_value < 0:
			return
	goal_hrs -= step_value
	if goal_min == 0:
		if goal_hrs == 1:
			hrs_down.disabled = true
	else:
		if goal_hrs == 0:
			hrs_down.disabled = true
	_update_values()

func _on_hrs_up_pressed() -> void:
	hrs_down.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if goal_hrs + step_value > 23:
		return
	goal_hrs += step_value
	if goal_hrs == 23:
		hrs_up.disabled = true
	if goal_min == 5 and goal_hrs == 1:
		min_down.disabled = false
	_update_values()

func _on_min_down_pressed() -> void:
	min_up.disabled = false
	var step_value := 5
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 10
	if goal_hrs == 0:
		if goal_min - step_value < 5:
			return
	else:
		if goal_min - step_value < 0:
			return
	if goal_min - step_value < 0:
		return
	goal_min -= step_value
	if goal_hrs == 0:
		if goal_min == 5:
			min_down.disabled = true
	else:
		if goal_min == 0:
			min_down.disabled = true
	_update_values()

func _on_min_up_pressed() -> void:
	min_down.disabled = false
	var step_value := 5
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 10
	if goal_min + step_value > 55:
		return
	goal_min += step_value
	if goal_min == 55:
		min_up.disabled = true
	if goal_hrs == 1:
		hrs_down.disabled = false
	_update_values()

func _on_set_pressed() -> void:
	Sidebar.get_tab("com.rosepen.focus").change_goal(goal_hrs*3600+goal_min*60)
	Popups.clear_popup()


func _on_cancel_pressed() -> void:
	Popups.clear_popup()
