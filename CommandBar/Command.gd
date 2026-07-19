extends Control
class_name Command
@onready var button: Button = $Button
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
signal hovered(pos_y)
signal selected(pos_y)
signal execute(path)

var manager: Control
var id: String
var path: String

var current_title
var current_icon_path
var current_command_path

func _on_mouse_entered() -> void:
	hovered.emit(position.y)

func _on_button_pressed() -> void:
	if manager.selection.position.y == position.y:
		execute.emit(path)
	else:
		selected.emit(position.y)

func init(title: String, icon_path: String, command_path: String):
	current_title = title
	current_icon_path = icon_path
	current_command_path = command_path
	label.text = title
	icon_rect.texture = load(icon_path)
	path = command_path

func set_no_results(setter: bool):
	if setter:
		label.text = "No commands found..."
		icon_rect.texture = Icons.QUSETIONCIRCLE
	else:
		init(current_title, current_icon_path, current_command_path)
