@tool
extends Control
class_name RGToggle
@onready var base: TextureRect = $TextureRect
@onready var ball: TextureRect = $Container/TextureRect

@export_enum("White","Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Red"
@export var accessible:bool = false
@export var is_toggled := false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

var _texture_path
var _hovered:bool = false

func set_color(new_color):
	if RoseGarden.Colors.verify_color(new_color,false) != OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	_update()
	return OK

func get_color():
	return color

func toggle():
	_on_pressed()
	return OK

func is_hovered():
	return _hovered

###############
#### STOP #### Here begin private functions that should never be called by your code
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
		_texture_path = "res://addons/RoseGarden/components/Toggle/BaseAccesible/"
	else:
		_texture_path = "res://addons/RoseGarden/components/Toggle/Base/"

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
		create_tween().tween_property(ball,"position",Vector2(6,ball.position.y),0.2*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SPRING)

func _show_on():
	base.texture = load(_texture_path+"Base"+color+".svg")
	if Engine.is_editor_hint():
		ball.position.x = 34
	else:
		create_tween().tween_property(ball,"position",Vector2(34,ball.position.y),0.2*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SPRING)

func _on_button_up() -> void:
	button_up.emit()
	if is_hovered():
		modulate = RoseGarden.Colors.COLOR_HOVERED
	else:
		modulate = RoseGarden.Colors.COLOR_NORMAL

func _on_button_down() -> void:
	button_down.emit()
	modulate = RoseGarden.Colors.COLOR_PRESSED

func _on_mouse_entered() -> void:
	_hovered = true
	modulate = RoseGarden.Colors.COLOR_HOVERED

func _on_mouse_exited() -> void:
	_hovered = false
	modulate = RoseGarden.Colors.COLOR_NORMAL

func _ready() -> void:
	_update()
