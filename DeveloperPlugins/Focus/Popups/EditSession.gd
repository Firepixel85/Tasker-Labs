extends Control

@onready var name_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer/NameField
@onready var project_menu: RGDropDown = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer2/ProjectMenu
@onready var error: RGText = $RGContainer/MarginContainer/VBoxContainer/Error
@onready var edit: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Edit

@onready var hrs_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Hrs/Hours/HrsField
@onready var hrs_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Hrs/Hours2/HrsDown
@onready var hrs_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Hrs/Hours2/HrsUp

@onready var min_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Min/HBoxContainer/MinField
@onready var min_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Min/HBoxContainer2/MinDown
@onready var min_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Min/HBoxContainer2/MinUp

@onready var sec_field: RGTextField = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Sec/HBoxContainer/SecField
@onready var sec_down: RGButton = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Sec/HBoxContainer2/SecDown
@onready var sec_up: RGButton = $RGContainer/MarginContainer/VBoxContainer/VBoxContainer3/HBoxContainer/Sec/HBoxContainer2/SecUp

var session:FocusSession
var time_tracked_hrs:int
var time_tracked_min:int
var time_tracked_sec:int

func _ready() -> void:
	edit.set_color(Settings.get_option_value("core.appearance/accent_color"))
	project_menu.canvas_layer_index = 3
	for project in Sidebar.get_tab("com.rosepen.focus").projects:
		project_menu.add_item(project,Sidebar.get_tab("com.rosepen.focus").project_ids[project])

func setup(new_session:FocusSession):
	session = new_session
	name_field.set_text(session.display_name)
	project_menu.select(Sidebar.get_tab("com.rosepen.focus").project_ids[session.get_project().display_name])
	@warning_ignore("integer_division")
	time_tracked_hrs = floor(session.tracked_time/3600)
	@warning_ignore("integer_division")
	time_tracked_min = floor((session.tracked_time%3600)/60)
	@warning_ignore("integer_division")
	time_tracked_sec = session.tracked_time%60
	name_field.placeholder_text = session.display_name

	if time_tracked_hrs == 0:
		hrs_down.disabled = true
	if time_tracked_hrs == 23:
		hrs_up.disabled = true
	if time_tracked_min == 0:
		min_down.disabled = true
	if time_tracked_min == 59:
		min_up.disabled = true
	if time_tracked_sec == 0:
		sec_down.disabled = true
	if time_tracked_sec == 59:
		sec_up.disabled = true

	_update_values()


func _update_values() -> void:
	hrs_field.set_text(str(time_tracked_hrs)+"h")
	min_field.set_text(str(time_tracked_min)+"m")
	sec_field.set_text(str(time_tracked_sec)+"s")

func _on_cancel_pressed() -> void:
	Popups.clear_popup()

func _on_edit_pressed() -> void:
	if name_is_empty():
		error.set_text("Session name cannot be empty.")
		error.modulate =  Color(1,1,1,1)
		name_field.incorrect = true
		name_field.edit()
		return
	if project_menu.get_selected_item() != session.get_project().display_name:
		session.change_project(Sidebar.get_tab("com.rosepen.focus").projects[project_menu.get_selected_item()])
	var time_delta := time_tracked_hrs*3600 + time_tracked_min*60 + time_tracked_sec - session.tracked_time
	if time_delta < 0:
		session.remove_time(-time_delta)
	elif time_delta > 0:
		session.add_time(time_delta)
	session.set_display_name(name_field.get_text())
	session.time_updated.emit(session.tracked_time)
	Popups.clear_popup()


func _on_hrs_down_pressed() -> void:
	hrs_up.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if time_tracked_hrs - step_value < 0:
		return
	time_tracked_hrs -= step_value
	if time_tracked_hrs == 0:
		hrs_down.disabled = true
	_update_values()

func _on_hrs_up_pressed() -> void:
	hrs_down.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if time_tracked_hrs + step_value > 23:
		return
	time_tracked_hrs += step_value
	if time_tracked_hrs == 23:
		hrs_up.disabled = true
	_update_values()

func _on_min_down_pressed() -> void:
	min_up.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if time_tracked_min - step_value < 0:
		return
	time_tracked_min -= step_value
	if time_tracked_min == 0:
		min_down.disabled = true
	_update_values()

func _on_min_up_pressed() -> void:
	min_down.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if time_tracked_min + step_value > 59:
		return
	time_tracked_min += step_value
	if time_tracked_min == 59:
		min_up.disabled = true
	_update_values()

func _on_sec_down_pressed() -> void:
	sec_up.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if time_tracked_sec - step_value < 0:
		return
	time_tracked_sec -= step_value
	if time_tracked_sec == 0:
		sec_down.disabled = true
	_update_values()

func _on_sec_up_pressed() -> void:
	sec_down.disabled = false
	var step_value := 1
	if Input.is_key_pressed(KEY_SHIFT):
		step_value = 5
	if time_tracked_sec + step_value > 59:
		return
	time_tracked_sec += step_value
	if time_tracked_sec == 59:
		sec_up.disabled = true
	_update_values()

func name_is_empty():
	if name_field.get_text() == "":
		return true
	for character in name_field.get_text().split(""):
		if character != " ":
			return false
	return true

func _on_name_field_text_changed(_new_text: String) -> void:
	name_field.incorrect = false
	error.modulate = Color(1,1,1,0)
