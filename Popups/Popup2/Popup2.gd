extends Control

@onready var container: MarginContainer = $RGContainer/MarginContainer
@onready var title_text: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var description_text: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var action1_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Action
@onready var action2_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Action2

var action1:Callable
var action1_params:Array
var action2:Callable
var action2_params:Array

func _on_close_pressed() -> void:
	Popups.remove_popup()

func setup(title:String,description:String,new_action:Array,new_action_params:Array,action_names:Array,colors:Array):
	title_text.text = title
	description_text.text = description
	action1 = new_action[0]
	action1_params = new_action_params[1]
	action2 = new_action[1]
	action2_params = new_action_params[1]
	action1_button.set_color(colors[0])
	action2_button.set_color(colors[1])
	action1_button.set_text(action_names[0])
	action2_button.set_text(action_names[1])
	await get_tree().process_frame
	await get_tree().process_frame
	custom_minimum_size.y = container.size.y + 40
	container.position = Vector2(0,0)

func _on_action1_pressed() -> void:
	action1.callv(action1_params)
	Popups.remove_popup()

func _on_action_2_pressed() -> void:
	action2.callv(action2_params)
	Popups.remove_popup()
