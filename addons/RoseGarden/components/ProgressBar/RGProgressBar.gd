@tool
extends Control
class_name RGProgressBar

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var value_text: Label = $MarginContainer/HBoxContainer/Label
@onready var value_container: HBoxContainer = $MarginContainer/HBoxContainer

@export var value: float = 0.0:
	set(new_value):
		if new_value < 0 or new_value > 100:
			return
		if bar == null:
			return
		value = new_value
		value_text.text = str(int(value)) + "%"
		bar.value = new_value
@export_enum("Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Pink", "Purple")
var color := "Red":
	set(new_value):
		if !RoseGarden.Colors.verify_color(new_value) == OK:
			return
		color = new_value
		if bar == null:
			return
		bar.texture_progress = load(
			RoseGarden._file_path + "ProgressBar/Progress/Progress " + color + ".svg"
		)
		bar.texture_over = load(RoseGarden._file_path + "ProgressBar/Top/Top " + color + ".svg")
		bar.texture_under = load(
			RoseGarden._file_path + "ProgressBar/Bottom/Bottom " + color + ".svg"
		)
		_value_update()
@export_enum("Left", "Center", "Right") var text_alignment = "Left":
	set(new_value):
		if new_value != "Left" and new_value != "Center" and new_value != "Right":
			push_error("Invalid text alignment: " + new_value)
			return
		text_alignment = new_value
		_update()
@export var show_value: bool = true:
	set(new_value):
		show_value = new_value
		_update()

signal value_changed(new_value: float)


func set_value(new_value: float):
	if new_value < 0 or new_value > 100:
		return ERR_INVALID_PARAMETER
	value = new_value
	bar.value = new_value
	_update()
	return OK


func get_value():
	return bar.value


func set_color(new_color: String):
	if !RoseGarden.Colors.verify_color(new_color) == OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	bar.texture_progress = load(
		RoseGarden._file_path + "ProgressBar/Progress/Progress " + color + ".svg"
	)
	bar.texture_over = load(RoseGarden._file_path + "ProgressBar/Top/Top " + color + ".svg")
	bar.texture_under = load(RoseGarden._file_path + "ProgressBar/Bottom/Bottom " + color + ".svg")
	_value_update()


func get_color():
	return color


func tween_value(
	new_value: float, duration: float, trans := Tween.TRANS_SINE, ease := Tween.EASE_IN_OUT
):
	var tween = create_tween()
	(
		tween
		. tween_property(
			self,
			"value",
			new_value,
			duration * int(!RoseGarden.Accessibility.get_disable_animations())
		)
		. set_ease(ease)
		. set_trans(trans)
	)
	if new_value < 0 or new_value > 100:
		return ERR_INVALID_PARAMETER
	return OK


##############
#### STOP #### Here begin private function that should never be called by your code
##############


func _ready() -> void:
	_value_update()
	RoseGarden.custom_textures_changed.connect(_update)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	RoseGarden.update_components.connect(_update)
	_update()
	_update_themes()


func _update():
	if bar == null:
		return
	bar.texture_progress = load(
		RoseGarden._file_path + "ProgressBar/Progress/Progress " + color + ".svg"
	)
	bar.texture_over = load(RoseGarden._file_path + "ProgressBar/Top/Top " + color + ".svg")
	bar.texture_under = load(RoseGarden._file_path + "ProgressBar/Bottom/Bottom " + color + ".svg")
	match text_alignment:
		"Left":
			value_container.alignment = BoxContainer.ALIGNMENT_BEGIN
		"Center":
			value_container.alignment = BoxContainer.ALIGNMENT_CENTER
		"Right":
			value_container.alignment = BoxContainer.ALIGNMENT_END

	value_container.visible = show_value
	value = clamp(value, 0, 100)
	bar.value = value
	value_text.text = str(int(value)) + "%"

	if custom_minimum_size < Vector2(60, 60):
		custom_minimum_size = Vector2(60, 60)

	set_color(color)


func _on_texture_progress_bar_value_changed(value: float) -> void:
	value_changed.emit(value)


func _value_update():
	value = clamp(value, 0, 100)
	bar.value = value
	value_text.text = str(int(value)) + "%"
	if (
		color == "White"
		or (
			(color == "Yellow" or color == "Green" or color == "Teal")
			and RoseGarden.Accessibility.get_increase_contrast()
		)
	):
		match text_alignment:
			"Left":
				if value <= 15:
					value_text.modulate = Color(1, 1, 1)
				else:
					value_text.modulate = Color(0, 0, 0)
			"Center":
				if value <= 55:
					value_text.modulate = Color(1, 1, 1)
				else:
					value_text.modulate = Color(0, 0, 0)
			"Right":
				if value <= 85:
					value_text.modulate = Color(1, 1, 1)
				else:
					value_text.modulate = Color(0, 0, 0)
	else:
		value_text.modulate = Color(1, 1, 1)


func _update_themes():
	value_text.theme = RoseGarden.Themes.Secondary
