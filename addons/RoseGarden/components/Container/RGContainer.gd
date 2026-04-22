@tool
extends Control

@onready var container:NinePatchRect = $NinePatchRect

@export_enum("8","16","32") var padding := "8"
@export var margin_number := 10

var patch_margins := {
	"8": 28,
	"16": 36,
	"32": 52
}

var margin_numbers := {
	"8": 10,
	"16": 18,
	"32": 34
}

func set_padding(new_padding:String):
	if !patch_margins.has(new_padding):
		return ERR_INVALID_PARAMETER
	padding = new_padding
	_update()
	return OK

###############
##### STOP #### Here begin private functions that should never be called by your code
###############

func _update():
	container.size = size
	container.texture = load(RoseGarden._file_path+"Container/Container"+padding+".svg")
	container.patch_margin_bottom = patch_margins[padding]
	container.patch_margin_left = patch_margins[padding]
	container.patch_margin_right = patch_margins[padding]
	container.patch_margin_top = patch_margins[padding]

func _process(_delta: float) -> void:
	margin_number = margin_numbers[padding]
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	RoseGarden.custom_themes_changed.connect(_update)
	_update()
