extends Control
class_name Command
@onready var button: Button = $Button
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
signal hovered(pos_y)
signal selected(pos_y)
signal execute(path)

var manager:Control
var id:String
var path:String

func _on_mouse_entered() -> void:
	hovered.emit(position.y)

func _on_button_pressed() -> void:
	if manager.selection.position.y == position.y:
		execute.emit(path)
	else:
		selected.emit(position.y)

func init(title:String,icon_path:String,command_path:String):
	label.text = title
	icon_rect.texture = ImageTexture.create_from_image(Image.load_from_file(icon_path))
	path = command_path
