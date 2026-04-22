@tool
extends Control
class_name RGTag
@onready var container: NinePatchRect = $NinePatchRect
@onready var label_container: MarginContainer = $NinePatchRect/MarginContainer
@onready var label: Label = $NinePatchRect/MarginContainer/VBoxContainer/Label

@export_enum("Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Red"
@export var text:String = "Tag"

func set_color(new_color:String):
	if RoseGarden.Colors.verify_color(new_color) != OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	return OK

func get_color():
	return color

func set_text(new_text:String):
	text = new_text
	await get_tree().create_timer(0.1).timeout
	_update()

func get_text():
	return text

###############
#### STOP #### Here begin private functions that should never be called by your code
###############

func _get_color_highlight():
	match color:
		"Red": return RoseGarden.Colors.RED_HIGHLIGHT
		"Orange": return RoseGarden.Colors.ORANGE_HIGHLIGHT
		"Yellow": return RoseGarden.Colors.YELLOW_HIGHLIGHT
		"Green": return RoseGarden.Colors.GREEN_HIGHLIGHT
		"Teal": return RoseGarden.Colors.TEAL_HIGHLIGHT
		"Blue": return RoseGarden.Colors.BLUE_HIGHLIGHT
		"Pink": return RoseGarden.Colors.PINK_HIGHLIGHT
		"Purple": return RoseGarden.Colors.PURPLE_HIGHLIGHT

func _update():
	label.text = text
	label.modulate = _get_color_highlight()
	size.x = label_container.get_minimum_size().x
	container.size.x = size.x
	container.texture = load(RoseGarden._file_path+"Tag/" + color + ".svg")

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	RoseGarden.custom_textures_changed.connect(_update)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update_themes()
	await get_tree().create_timer(0.1).timeout
	_update()
	

func _update_themes():
	label.theme = RoseGarden.Themes.Secondary
