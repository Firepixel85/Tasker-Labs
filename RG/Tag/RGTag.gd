@tool
extends Control
class_name RGTag
@onready var container: NinePatchRect = $NinePatchRect
@onready var label_container: MarginContainer = $NinePatchRect/MarginContainer
@onready var label: Label = $NinePatchRect/MarginContainer/VBoxContainer/Label

@export_enum("Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Red"
@export var text:String = "Tag"

func set_color(new_color:String):
	if Colors.verify_color(new_color) != OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	return OK

func get_color():
	return color

func set_text(new_text:String):
	text = new_text
	_update()

func get_text():
	return text

###############
#### STOP #### Here begin private function that should never be called by your code
###############

func _get_color_highlight():
	match color:
		"Red": return Colors.RED_HIGHLIGHT
		"Orange": return Colors.ORANGE_HIGHLIGHT
		"Yellow": return Colors.YELLOW_HIGHLIGHT
		"Green": return Colors.GREEN_HIGHLIGHT
		"Teal": return Colors.TEAL_HIGHLIGHT
		"Blue": return Colors.BLUE_HIGHLIGHT
		"Pink": return Colors.PINK_HIGHLIGHT
		"Purple": return Colors.PURPLE_HIGHLIGHT

func _update():
	custom_minimum_size = Vector2(0,0)
	custom_minimum_size = Vector2(label_container.get_minimum_size().x,40)
	container.size.x = custom_minimum_size.x
	label.text = text
	label.modulate = _get_color_highlight()
	container.texture = load("res://RG/Tag/" + color + ".svg")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	_update()
