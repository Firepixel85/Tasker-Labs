@tool
extends Control
class_name RGButton
@onready var base: NinePatchRect = $NinePatchRect
@onready var text_container: HBoxContainer = $HBoxContainer
@onready var label: Label = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/Label
@onready var button: Button = $Button
@onready var texture: TextureRect = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/TextureRect
@onready var content_margin: MarginContainer = $HBoxContainer/VBoxContainer/MarginContainer

@export_category("Appearence")
@export_enum("Gray","White","Red","Orange","Yellow","Green","Blue","Pink","Purple") var color := "Gray"
@export var text := "Button"
@export var icon:Texture2D

@export_category("Button Controls")
@export var disabled:bool = false
@export var toggle_mode:bool = false
@export var button_pressed:bool = false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

const _COLOR_NORMAL = Color(1,1,1)
const _COLOR_PRESSED = Color(0.65,0.65,0.65)
const _COLOR_HOVERED = Color(0.85,0.85,0.85)
const _COLOR_DISABLED = Color(0.6,0.6,0.6)
const _COLOR_DISABLED_HOVERED = Color(0.55,0.55,0.55)

func set_color(new_color:String):
	color = new_color
	base.texture = load("res://RG/Button/Base"+color+".svg")
	if color == "White" or color == "Yelllow" or color == "Greeen":
		label.modulate = Color(0,0,0)
		texture.modulate = Color(0,0,0)
	else:
		label.modulate = Color(1,1,1)
		texture.modulate = Color(1,1,1)
	_update()

func set_icon(new_icon:Texture2D):
	icon = new_icon
	_update()

func set_text(new_text:String):
	text=new_text
	_update()

##############
#### STOP #### Here begin private function that should never be called by your code
##############

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_color(color)
		_update()

func _update():
	label.text = text
	texture.texture = icon
	custom_minimum_size.x = label.size.x+texture.size.x+136
	label.visible = true
	content_margin.add_theme_constant_override("margin_left",64)
	content_margin.add_theme_constant_override("margin_right",64)
	label.get_parent().add_theme_constant_override("separation",8)

	if text == "":
		label.get_parent().add_theme_constant_override("separation",0)
		content_margin.add_theme_constant_override("margin_left",6)
		content_margin.add_theme_constant_override("margin_right",6)
		custom_minimum_size.x = 60
		label.visible = false
	if get_parent().is_class("BoxContainer") and !(size_flags_horizontal & Control.SIZE_EXPAND):
		size = custom_minimum_size
	text_container.size.x = size.x
	base.size.x = text_container.size.x
	_mirror_to_button()
	if disabled:
		modulate = _COLOR_DISABLED
	else:
		modulate = _COLOR_NORMAL

func _ready() -> void:
	set_color(color)
	_update()

func _mirror_to_button():
	button.disabled = disabled
	button.toggle_mode = toggle_mode
	button.button_pressed = button_pressed


func _on_button_down() -> void:
	if disabled:
		pass
	else:
		modulate = _COLOR_PRESSED
	button_down.emit()

func _on_button_up() -> void:
	if disabled:
		modulate = _COLOR_DISABLED_HOVERED
	else:
		modulate = _COLOR_HOVERED
	button_up.emit()

func _on_pressed() -> void:
	pressed.emit()

func _on_toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)

func _on_mouse_entered() -> void:
	if disabled:
		modulate = _COLOR_DISABLED_HOVERED
	else:
		modulate = _COLOR_HOVERED

func _on_mouse_exited() -> void:
	if disabled:
		modulate = _COLOR_DISABLED
	else:
		modulate = _COLOR_NORMAL
