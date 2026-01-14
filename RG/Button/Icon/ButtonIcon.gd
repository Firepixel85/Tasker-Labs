@tool
extends Control
@onready var base: NinePatchRect = $NinePatchRect
@onready var text_container: HBoxContainer = $HBoxContainer
@onready var button: Button = $Button
@onready var texture: TextureRect = $MarginContainer/HBoxContainer/VBoxContainer/TextureRect

@export_category("Appearence")
@export_enum("Gray","Green","Red","Blue","Accent","White") var color := "Gray"
@export var icon:Texture2D
@export_category("Button Controls")
@export var disabled:bool = false
@export var toggle_mode:bool = false
@export var button_pressed:bool = false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		change_color(color)
		_update()

func _update():
	texture.texture = icon
	_mirror_to_button()

func _ready() -> void:
	change_color(color)
	_update()

func change_color(new_color:String):
	color = new_color
	base.texture = load("res://RG/Button/Base"+color+".png")
	if color == "White":
		texture.modulate = Color(0,0,0)
	else:
		texture.modulate = Color(1,1,1)
	_update()

func change_icon(new_icon:Texture2D):
	icon = new_icon
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
	modulate = Color(0.85,0.85,0.85)
	button_down.emit()

func _on_button_up() -> void:
	modulate = Color(1,1,1)
	button_up.emit()

func _on_pressed() -> void:
	pressed.emit()

func _on_toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)

func _on_mouse_entered() -> void:
	modulate = Color(0.9,0.9,0.9)

func _on_mouse_exited() -> void:
	modulate = Color(1,1,1)
	
