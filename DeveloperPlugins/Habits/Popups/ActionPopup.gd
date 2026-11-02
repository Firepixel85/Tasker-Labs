extends Control
@onready var confirm: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Confirm
@onready var title: RGText = $RGContainer/MarginContainer/VBoxContainer/Title
@onready var habit_select: RGDropDown = $RGContainer/MarginContainer/VBoxContainer/HabitSelect

signal habit_selected(habit:int)

func setup(action:String,habit_list:Dictionary):
	habit_select.canvas_layer_index = 3
	confirm.set_text(action)
	if action == "Delete":
		confirm.set_color("Red")
	else:
		confirm.set_color(Settings.get_option_value("core.appearance/accent_color"))
	if action ==  "Check In":
		title.set_text("Check in for habit")
	else:
		title.set_text(action+" habit")
	for key in habit_list.keys():
		habit_select.add_item(habit_list[key],key)
	await get_tree().create_timer(0.1).timeout
	habit_select.open()
	await get_tree().create_timer(0.1).timeout
	if !habit_select._is_open:
		habit_select.open()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		confirm.press()

func _on_confirm_pressed() -> void:
	habit_selected.emit(habit_select.get_selected())
	Popups.clear_popup()

func _on_habit_select_new_selection(_selection: String) -> void:
	habit_selected.emit(habit_select.get_selected())
	Popups.clear_popup()
