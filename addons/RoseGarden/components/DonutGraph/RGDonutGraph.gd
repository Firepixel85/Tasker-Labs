@tool
extends Control
class_name RGDonutGraph
@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var value_label: Label = $TextureProgressBar/CenterContainer/VBoxContainer/Label
@onready var value_name_label: RGText = $TextureProgressBar/CenterContainer/VBoxContainer/RGText

@export var value: int = 0
@export_enum("Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Red"
@export_enum("Percentage","Value") var mode = "Percentage"
@export var value_name:String = ""
@export var percentage:int = 0

signal value_changed(new_value:float)
signal mode_chnaged(new_mode:String)

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
	if !RoseGarden.Colors.verify_color(new_color) == OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	_value_update()
	return OK

func get_color():
	return color

func set_mode(new_mode:String):
	if new_mode != "Value" or new_mode != "Percentage":
		return ERR_INVALID_PARAMETER
	mode = new_mode
	_update()

func get_mode():
	return mode

func set_value_name(new_name:String):
	value_name = new_name
	_update()
	return OK

func set_percentage(new_per:int):
	if (new_per < 0 or new_per > 100) and mode == "Percentage":
		return ERR_INVALID_PARAMETER
	percentage = new_per
	_update()
	return OK

func tween_value(new_value:int, duration:float,new_perc:int=percentage,trans := Tween.TRANS_SINE,ease := Tween.EASE_IN_OUT):
	var tween = create_tween()
	tween.parallel().tween_property(self, "value", new_value, duration*int(!RoseGarden.Accessibility.get_disable_animations())).set_ease(ease).set_trans(trans)
	tween.parallel().tween_property(self, "percentage", new_perc, duration*int(!RoseGarden.Accessibility.get_disable_animations())).set_ease(ease).set_trans(trans)
	if new_value < 0 or new_value > 100:
		return ERR_INVALID_PARAMETER
	return OK

func _ready() -> void:
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update()
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_update()
	_value_update()
		
func _update():
	bar.texture_progress = load(RoseGarden._file_path+"DonutGraph/Progress/Progress"+color+".svg")
	bar.texture_under = load(RoseGarden._file_path+"DonutGraph/Base/Base"+color+".svg")
	value_name_label.custom_color = RoseGarden.Colors.get_color(color)
	value_name_label._update()
	match mode:
		"Value":
			value_name_label.visible = true
			value_name_label.text = value_name
			_value_update()
		"Percentage":
			value_name_label.visible = false
			_value_update()

func _value_update():
	value = clamp(value,0,100)
	percentage = clamp(percentage,0,100)

	if mode == "Percentage":
		bar.value = value
	else:
		bar.value = percentage
	value_label.text = str(int(value))
	if mode == "Percentage":
		value_label.text += "%"

func _update_themes():
	value_label.theme = RoseGarden.Themes.Main
