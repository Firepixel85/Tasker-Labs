@tool
extends Control
@onready var base: TextureRect = $TextureRect
@onready var ball: TextureRect = $Container/TextureRect

@export_enum("Gray","White","Red","Orange","Yellow","Green","Blue","Pink","Purple") var color := "Gray"
@export var accessible:bool = false
@export var is_toggled := false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

var _texture_path

const _COLOR_NORMAL = Color(1,1,1)
const _COLOR_PRESSED = Color(0.65,0.65,0.65)
const _COLOR_HOVERED = Color(0.85,0.85,0.85)
const _COLOR_DISABLED = Color(0.6,0.6,0.6)
const _COLOR_DISABLED_HOVERED = Color(0.55,0.55,0.55)

func _on_pressed() -> void:
	if is_toggled:
		is_toggled = false
		_show_off()
	else:
		is_toggled = true
		_show_on()
	pressed.emit()
	toggled.emit(is_toggled)
		

func _update():
	if accessible:
		_texture_path = "res://RG/Toggle/BaseAccesible/"
	else:
		_texture_path = "res://RG/Toggle/Base/"
	
	if is_toggled:
		_show_on()
	else:
		_show_off()

func set_color(new_color):
	color = new_color
	_update()
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _show_off():
	base.texture = load(_texture_path+"BaseGray.svg")
	if Engine.is_editor_hint():
		ball.position.x = 3
	else:
		create_tween().tween_property(ball,"position",Vector2(3,ball.position.y),0.2).set_trans(Tween.TRANS_SPRING)

func _show_on():
	base.texture = load(_texture_path+"Base"+color+".svg")
	if Engine.is_editor_hint():
		ball.position.x = 17
	else:
		create_tween().tween_property(ball,"position",Vector2(17,ball.position.y),0.2).set_trans(Tween.TRANS_SPRING)
		
func toggle():
	_on_pressed()

func _on_button_up() -> void:
	button_up.emit()
	modulate = _COLOR_NORMAL

func _on_button_down() -> void:
	button_down.emit()
	modulate = _COLOR_PRESSED


func _on_mouse_entered() -> void:
	modulate = _COLOR_HOVERED

func _on_mouse_exited() -> void:
	modulate = _COLOR_NORMAL

func _ready() -> void:
	_update()
