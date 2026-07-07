@tool
extends Control
class_name RGToggle
@onready var base: TextureRect = $TextureRect
@onready var ball: TextureRect = $Container/TextureRect

@export_enum("White", "Red", "Orange", "Yellow", "Green", "Teal", "Blue", "Pink", "Purple")
var color := "Red":
	set(new_value):
		if RoseGarden.Colors.verify_color(new_value, false) != OK:
			return ERR_INVALID_PARAMETER
		color = new_value
		_update()
@export var accessible: bool = false:
	set(new_value):
		accessible = new_value
		_update()
@export var is_toggled := false:
	set(new_value):
		is_toggled = new_value
		_update()

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on: bool)
signal hovered
signal dehovered

var _texture_path
var _hovered: bool = false
var dont_animate: bool = false


func set_color(new_color):
	if RoseGarden.Colors.verify_color(new_color, false) != OK:
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


func set_state(state: bool, no_animation: bool = false):
	is_toggled = state
	dont_animate = no_animation
	_update()


func set_accessible(is_accessible: bool):
	accessible = is_accessible
	_update()


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
	if base == null:
		return
	if accessible:
		_texture_path = RoseGarden._get_file_path() + "Toggle/BaseAccesible/"
	else:
		_texture_path = RoseGarden._get_file_path() + "Toggle/Base/"

	if is_toggled:
		_show_on()
	else:
		_show_off()


func _show_off():
	base.texture = load(_texture_path + "BaseGray.svg")
	if Engine.is_editor_hint():
		ball.position.x = 6
	else:
		(
			create_tween()
			. tween_property(
				ball,
				"position",
				Vector2(6, ball.position.y),
				(
					0.2
					* int(!RoseGarden.Accessibility.get_disable_animations())
					* int(!dont_animate)
					* int(RoseGarden.Animations.togglePress)
				)
			)
			. set_trans(Tween.TRANS_SPRING)
		)
	dont_animate = false


func _show_on():
	base.texture = load(_texture_path + "Base" + color + ".svg")
	if Engine.is_editor_hint():
		ball.position.x = 34
	else:
		(
			create_tween()
			. tween_property(
				ball,
				"position",
				Vector2(34, ball.position.y),
				(
					0.2
					* int(!RoseGarden.Accessibility.get_disable_animations())
					* int(!dont_animate)
					* int(RoseGarden.Animations.togglePress)
				)
			)
			. set_trans(Tween.TRANS_SPRING)
		)
	dont_animate = false


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
	hovered.emit()


func _on_mouse_exited() -> void:
	_hovered = false
	modulate = RoseGarden.Colors.COLOR_NORMAL
	dehovered.emit()


func _ready() -> void:
	RoseGarden.custom_textures_changed.connect(_update)
	RoseGarden.flags_changed.connect(_update_flags)
	_update()


func _update_flags(flag_name: String, new_value: bool):
	if flag_name == "accessible_toggles":
		accessible = new_value
		_update()
