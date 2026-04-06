@tool
extends Control
class_name RGProgressBar

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var value_text: Label = $MarginContainer/HBoxContainer/Label
@onready var value_container: HBoxContainer = $MarginContainer/HBoxContainer

@export var value: float = 0.0
@export_enum("Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Red"
@export_enum("Left","Center","Right") var text_alignment = "Left"
@export var show_value: bool = true

signal value_changed(new_value:float)

func set_value(new_value:float):
	if new_value < 0 or new_value > 100:
		return ERR_INVALID_PARAMETER
	value = new_value
	bar.value = new_value
	_update()
	return OK

func get_value():
	return bar.value

func set_color(new_color:String):
	if !Colors.verify_color(new_color) == OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	_value_update()

func get_color():
	return color

##############
#### STOP #### Here begin private function that should never be called by your code
##############

func _ready() -> void:
	_update()
	_value_update()

func _update():
	match text_alignment:
		"Left":
			value_container.alignment = BoxContainer.ALIGNMENT_BEGIN
		"Center":
			value_container.alignment = BoxContainer.ALIGNMENT_CENTER
		"Right":
			value_container.alignment = BoxContainer.ALIGNMENT_END

	value_container.visible = show_value
	value = clamp(value,0,100)
	bar.value = value
	value_text.text = str(int(value))+"%"

	bar.texture_progress = load("res://RG/Progress Bar/Progress/Progress "+color+".svg")
	bar.texture_over = load("res://RG/Progress Bar/Top/Top "+color+".svg")
	bar.texture_under = load("res://RG/Progress Bar/Bottom/Bottom "+color+".svg")

	if custom_minimum_size < Vector2(60,60):
		custom_minimum_size = Vector2(60,60)

func _process(_delta:float) -> void:
	if Engine.is_editor_hint():
		_update()
	_value_update()


func _on_texture_progress_bar_value_changed(value: float) -> void:
	value_changed.emit(value)

func _value_update():
	value = clamp(value,0,100)
	bar.value = value
	value_text.text = str(int(value))+"%"
	if color == "White" or ((color == "Yellow" or color == "Green" or color == "Teal") and RoseGarden.Accessibility.get_increase_contrast()):
		match text_alignment:
			"Left":
				if value<=15:
					value_text.modulate = Color(1,1,1)
				else:
					value_text.modulate = Color(0,0,0)
			"Center":
				if value<=55:
					value_text.modulate = Color(1,1,1)
				else:
					value_text.modulate = Color(0,0,0)
			"Right":
				if value<=85:
					value_text.modulate = Color(1,1,1)
				else:
					value_text.modulate = Color(0,0,0)
	else:
		value_text.modulate = Color(1,1,1)
