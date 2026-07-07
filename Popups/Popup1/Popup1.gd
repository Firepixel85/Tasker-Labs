extends Control

@onready var container: MarginContainer = $RGContainer/MarginContainer
@onready var title_text: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var description_text: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var action_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Action
@onready var title_spacer: Control = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleSpacer

var action:Callable
var action_params:Array

func _on_close_pressed() -> void:
	Popups.clear_popup()

func _on_action_pressed() -> void:
	action.callv(action_params)
	Popups.clear_popup()

func setup(title:String,description:String,new_action:Callable,new_action_params:Array,action_name:String,color:String,title_alignment:int):
	title_text.text = title
	description_text.text = description
	action = new_action
	action_params = new_action_params
	action_button.set_text(action_name)
	action_button.set_color(color)
	match title_alignment:
		0:
			title_text.horizontal_alignment = "Left"
		1:
			title_spacer.visible = true
			title_text.horizontal_alignment = "Center"
		2:
			title_spacer.visible = false
			title_text.horizontal_alignment = "Right"
	await get_tree().process_frame
	await get_tree().process_frame
	custom_minimum_size.y = container.get_minimum_size().y
	container.get_parent()._update()
	title_text._update()
	container.position = Vector2(0,0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		action_button.press()
