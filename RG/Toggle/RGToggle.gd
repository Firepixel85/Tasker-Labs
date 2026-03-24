@tool
extends Control
@onready var base: TextureRect = $TextureRect
@onready var ball: TextureRect = $Container/TextureRect

@export_enum("Gray","White","Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Gray"
@export var accessible:bool = false
@export var is_toggled := false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

var _texture_path

func set_color(new_color):
	if Colors.verify_color(new_color,true) != OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	return OK

func get_color():
	return color

func toggle():
	_on_pressed()
	return OK

###############
#### STOP #### Here begin private function that should never be called by your code
###############

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

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _show_off():
	base.texture = load(_texture_path+"BaseGray.svg")
	if Engine.is_editor_hint():
		ball.position.x = 6
	else:
		create_tween().tween_property(ball,"position",Vector2(6,ball.position.y),0.2).set_trans(Tween.TRANS_SPRING)

func _show_on():
	base.texture = load(_texture_path+"Base"+color+".svg")
	if Engine.is_editor_hint():
		ball.position.x = 34
	else:
		create_tween().tween_property(ball,"position",Vector2(34,ball.position.y),0.2).set_trans(Tween.TRANS_SPRING)

func _on_button_up() -> void:
	button_up.emit()
	modulate = Colors.COLOR_NORMAL

func _on_button_down() -> void:
	button_down.emit()
	modulate = Colors.COLOR_PRESSED

func _on_mouse_entered() -> void:
	modulate = Colors.COLOR_HOVERED

func _on_mouse_exited() -> void:
	modulate = Colors.COLOR_NORMAL

func _ready() -> void:
	_update()
