extends Control

@onready var container: MarginContainer = $RGContainer/MarginContainer
@onready var title_text: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var description_text: Label = $RGContainer/MarginContainer/VBoxContainer/Description

func _on_close_pressed() -> void:
	Popups.clear_popup()

func setup(title:String,description:String):
	print("test")
	title_text.text = title
	description_text.text = description
	await get_tree().process_frame
	await get_tree().process_frame
	custom_minimum_size.y = container.size.y + 40
	container.position = Vector2(0,0)
