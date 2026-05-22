@tool
extends Control
class_name RGtoast
@onready var base: NinePatchRect = $NinePatchRect
@onready var label: Label = $NinePatchRect/CenterContainer/Label
@onready var button: Button = $Button

@export var text:String = "Toast"
@export_enum("Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color = "Blue"

func set_text(new_text:String):
	text = new_text
	_update()
	return OK

func set_color(new_color:String):
	if RoseGarden.Colors.verify_color(new_color) != OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	return OK

func _update():
	base.texture = load(RoseGarden._get_file_path()+"Toast/Base/Base"+color+".png")
	label.text = text
	base.size.x = label.get_minimum_size().x + 120
	size = base.size
	button.size = size

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update()


func _on_button_pressed() -> void:
	RoseGarden.clear_toast()
