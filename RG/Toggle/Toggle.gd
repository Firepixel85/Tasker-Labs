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
	base.texture = load(_texture_path+"BaseGray.png")
	if Engine.is_editor_hint():
		ball.position.x = 3
	else:
		create_tween().tween_property(ball,"position",Vector2(3,ball.position.y),0.2).set_trans(Tween.TRANS_SPRING)

func _show_on():
	base.texture = load(_texture_path+"Base"+color+".png")
	if Engine.is_editor_hint():
		ball.position.x = 17
	else:
		create_tween().tween_property(ball,"position",Vector2(17,ball.position.y),0.2).set_trans(Tween.TRANS_SPRING)
		
func toggle():
	_on_pressed()

func _on_button_up() -> void:
	button_up.emit()
	modulate = Color(1,1,1)

func _on_button_down() -> void:
	button_down.emit()
	modulate = Color(0.85,0.85,0.85)


func _on_mouse_entered() -> void:
	modulate = Color(0.9,0.9,0.9)

func _on_mouse_exited() -> void:
	modulate = Color(1,1,1)

func _ready() -> void:
	_update()
