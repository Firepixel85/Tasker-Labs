extends Control

@onready var container: MarginContainer = $RGContainer/MarginContainer
@onready var title_text: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var description_text: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var action1_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Action1
@onready var action2_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Action2
@onready var title_spacer: Control = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleSpacer
@onready var close: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Close

var action1:Callable
var action1_params:Array
var action2:Callable
var action2_params:Array

func _on_close_pressed() -> void:
	Popups.clear_popup()

func setup(prefab:TSKPopup):
	title_text.text = prefab.title
	description_text.text = prefab.description
	action1 = prefab.actions[0]
	action1_params = prefab.action_params[0]
	action2 = prefab.actions[1]
	action2_params = prefab.action_params[1]
	action1_button.set_text(prefab.action_names[0])
	action2_button.set_text(prefab.action_names[1])
	action1_button.set_color(prefab.colors[0])
	action2_button.set_color(prefab.colors[1])
	match prefab.title_alignment:
		0:
			title_text.horizontal_alignment = "Left"
		1:
			title_spacer.visible = true
			title_text.horizontal_alignment = "Center"
		2:
			title_spacer.visible = false
			title_text.horizontal_alignment = "Right"
	match prefab.description_alignment:
		0:
			description_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		1:
			description_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		2:
			description_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	if !prefab.show_close_button:
		close.hide()
		title_spacer.hide()
	await get_tree().process_frame
	await get_tree().process_frame
	custom_minimum_size.y = container.get_minimum_size().y
	container.get_parent()._update()
	title_text._update()
	container.position = Vector2(0,0)

func _on_action1_pressed() -> void:
	action1.callv(action1_params)
	Popups.clear_popup()

func _on_action_2_pressed() -> void:
	action2.callv(action2_params)
	Popups.clear_popup()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		action2_button.press()
