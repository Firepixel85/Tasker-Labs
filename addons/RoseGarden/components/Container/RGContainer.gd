@tool
extends Control

@onready var container:NinePatchRect = $NinePatchRect

@export_enum("8","16","32") var padding := "8":
	set(new_value):
		if !patch_margins.has(new_value):
			return
		padding = new_value
		margin_number = margin_numbers[new_value]
		_update()
@export var margin_number := 10:
	set(new_value):
		if new_value != margin_numbers[padding]:
			return
		margin_number = new_value

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
	if container == null:
		return
	container.texture = load(RoseGarden._file_path+"Container/Container"+padding+".svg")
	container.patch_margin_bottom = patch_margins[padding]
	container.patch_margin_left = patch_margins[padding]
	container.patch_margin_right = patch_margins[padding]
	container.patch_margin_top = patch_margins[padding]
	await get_tree().process_frame
	container.size = size

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	RoseGarden.custom_themes_changed.connect(_update)
	_update()
