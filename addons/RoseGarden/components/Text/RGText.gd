@tool
extends Control
class_name RGText

@onready var label: Label = $Label

@export_category("Appearence")
@export var text:String = "Text"
@export_enum("Large","Main","Secondary","Info","FinePrint") var font_size = "Main"
@export var rounded:bool = false
@export_enum("Main","Secondary","Dark","Custom") var color = "Main"
@export var custom_color:Color = Color(1,1,1)

@export_category("Behavior")
@export_enum("Left","Center","Right","Fill") var horizontal_alignment = "Left"
@export_enum("Top","Center","Bottom","Fill") var vertical_alignment = "Top"

func set_color(new_color:String):
	if !new_color == "Main" or new_color == "Secondary" or new_color == "Dark" or new_color == "Custom":
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	return OK

func set_font_size(new_font_size:String):
	if !new_font_size == "Main" or new_font_size == "Secondary" or new_font_size == "Info" or new_font_size == "FinePrint":
		return ERR_INVALID_PARAMETER
	font_size = new_font_size
	_update()
	return OK

func set_rounded(is_rounded:bool):
	rounded = is_rounded
	_update()
	return OK

func set_text(new_text:String):
	text = new_text
	_update()
	return OK

##############
#### STOP #### Here begin private function that should never be called by your code
##############

func _ready():
	RoseGarden.custom_themes_changed.connect(_update)
	_update()

func _update():
	var theme_path = str(RoseGarden._theme_path)+font_size
	if rounded:
		theme_path += "Round.tres"
	else:
		theme_path += ".tres"
	label.theme = load(theme_path)
	match color:
		"Main":
			label.add_theme_color_override("font_color",RoseGarden.Colors.TEXT_MAIN)
		"Secondary":
			label.add_theme_color_override("font_color",RoseGarden.Colors.TEXT_SECONDARY)
		"Dark":
			label.add_theme_color_override("font_color",RoseGarden.Colors.TEXT_DARK)
		"Custom":
			label.add_theme_color_override("font_color",custom_color)
	label.text = text
	custom_minimum_size = label.get_minimum_size()
	label.size = size
	match horizontal_alignment:
		"Left":
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		"Center":
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		"Right":
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		"Fill":
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_FILL
	match vertical_alignment:
		"Top":
			label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		"Center":
			label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		"Bottom":
			label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		"Fill":
			label.vertical_alignment = VERTICAL_ALIGNMENT_FILL

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()
