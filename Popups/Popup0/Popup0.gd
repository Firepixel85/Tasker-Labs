extends Control

@onready var container: MarginContainer = $RGContainer/MarginContainer
@onready var title_text: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var description_text: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready
var title_spacer: Control = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TitleSpacer


func _on_close_pressed() -> void:
	Popups.clear_popup()


func setup(title: String, description: String, title_alignment: int):
	title_text.text = title
	description_text.text = description
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
	container.position = Vector2(0, 0)
