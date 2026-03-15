@tool
extends Control
class_name ButtonText
@onready var base: NinePatchRect = $NinePatchRect
@onready var text_container: HBoxContainer = $HBoxContainer
@onready var label: Label = $HBoxContainer/VBoxContainer/MarginContainer/Label
@onready var button: Button = $Button

@export_category("Appearence")
@export_enum("Gray","White","Red","Orange","Yellow","Green","Blue","Pink","Purple") var color := "Gray"
@export var text := "Button"

@export_category("Button Controls")
@export var disabled:bool = false
@export var toggle_mode:bool = false
@export var button_pressed:bool = false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

const _COLOR_NORMAL = Color(1,1,1)
const _COLOR_PRESSED = Color(0.83,0.83,0.83)
const _COLOR_HOVERED = Color(0.9,0.9,0.9)
const _COLOR_DISABLED = Color(0.7,0.7,0.7)
const _COLOR_DISABLED_HOVERED = Color(0.6,0.6,0.6)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_color(color)
		_update()

func _update():
	label.text = text
	text_container.size.x = size.x
	base.size.x = text_container.size.x
	custom_minimum_size.x = label.size.x+64
	if disabled:
		modulate = _COLOR_DISABLED
	else:
		modulate = _COLOR_NORMAL
func _ready() -> void:
	set_color(color)
	_update()
	_mirror_to_button()

func set_color(new_color:String):
	color = new_color
	base.texture = load("res://RG/Button/Base"+color+".png")
	if color == "White":
		label.modulate = Color(0,0,0)
	else:
		label.modulate = Color(1,1,1)
	_update()
	
func set_text(new_text:String):
	text = new_text
	_update()

func _mirror_to_button():
	button.disabled = disabled
	button.toggle_mode = toggle_mode
	button.button_pressed = button_pressed

func update_loop():
	while true:
		await get_tree().create_timer(0.5).timeout
		_update()

func _on_button_down() -> void:
	if disabled:
		pass
	else:
		modulate = _COLOR_PRESSED
	button_down.emit()

func _on_button_up() -> void:
	if disabled:
		pass
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
