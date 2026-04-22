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
@export_enum("Gray","White","Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Gray"
@export var text := "Button"
@export var icon:Texture2D
@export_enum("None","Left","Right","Both") var connection := "None"

@export_category("Button Controls")
@export var disabled:bool = false
@export var toggle_mode:bool = false
@export var button_pressed:bool = false

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)

var _hovered:bool = false

func set_color(new_color:String):
	if !Engine.is_editor_hint():
		if RoseGarden.Colors.verify_color(new_color,true) != OK:
			return ERR_INVALID_PARAMETER
	color = new_color
	match connection:
		"None":
			base.texture = load(RoseGarden._get_file_path()+"Button/Base/Base"+color+".svg")
		"Left":
			base.texture = load(RoseGarden._get_file_path()+"Button/BaseLeft/Base"+color+".svg")
		"Right":
			base.texture = load(RoseGarden._get_file_path()+"Button/BaseRight/Base"+color+".svg")
		"Both":
			base.texture = load(RoseGarden._get_file_path()+"Button/BaseBoth/Base"+color+".svg")
	if color == "White" or ((color == "Yellow" or color == "Green" or color == "Teal") and RoseGarden.Accessibility.get_increase_contrast()):
		label.modulate = Color(0,0,0)
		texture.modulate = Color(0,0,0)
	else:
		label.modulate = Color(1,1,1)
		texture.modulate = Color(1,1,1)
	_update()
	return OK

func set_icon(new_icon:Texture2D):
	icon = new_icon
	_update()
	return OK

func set_text(new_text:String):
	text=new_text
	_update()
	return OK

func get_color():
	return color

func get_icon():
	return icon

func get_text():
	return text

func is_hovered():
	return _hovered

func press():
	if disabled:
		return ERR_LOCKED
	await _on_button_down()
	_on_button_up()
	pressed.emit()


##############
#### STOP #### Here begin private functions that should never be called by your code
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
		modulate = RoseGarden.Colors.COLOR_DISABLED
	else:
		modulate = RoseGarden.Colors.COLOR_NORMAL
	match connection:
		"None","Both":
			pivot_offset = size/2
		"Left":
			pivot_offset = Vector2(0,size.y/2)
		"Right":
			pivot_offset = Vector2(size.x,size.y/2)

func _ready() -> void:
	set_color(color)
	_update()
	RoseGarden.custom_textures_changed.connect(_update_textures)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update_textures()
	_update_themes()

func _mirror_to_button():
	button.disabled = disabled
	button.toggle_mode = toggle_mode
	button.button_pressed = button_pressed


func _on_button_down() -> void:
	var tween = create_tween()
	if disabled:
		pass
	else:
		modulate = RoseGarden.Colors.COLOR_PRESSED
	button_down.emit()
	if RoseGarden.Accessibility.get_disable_animations():
		return
	if connection != "Both":
		tween.tween_property(self,"scale",Vector2(0.95,0.95),0.1).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(self,"scale",Vector2(1,0.9),0.1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	return

func _on_button_up() -> void:
	var tween = create_tween()
	if disabled:
		if is_hovered():
			modulate = RoseGarden.Colors.COLOR_DISABLED_HOVERED
		else:
			modulate = RoseGarden.Colors.COLOR_DISABLED
	else:
		if is_hovered():
			modulate = RoseGarden.Colors.COLOR_HOVERED
		else:
			modulate = RoseGarden.Colors.COLOR_NORMAL
	button_up.emit()
	if RoseGarden.Accessibility.get_disable_animations():
		return
	tween.tween_property(self,"scale",Vector2(1,1),0.1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	return

func _on_pressed() -> void:
	pressed.emit()

func _on_toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)

func _on_mouse_entered() -> void:
	_hovered = true
	if disabled:
		modulate = RoseGarden.Colors.COLOR_DISABLED_HOVERED
	else:
		modulate = RoseGarden.Colors.COLOR_HOVERED

func _on_mouse_exited() -> void:
	_hovered = false
	if disabled:
		modulate = RoseGarden.Colors.COLOR_DISABLED
	else:
		modulate = RoseGarden.Colors.COLOR_NORMAL

func _update_textures():
	match connection:
		"None":
			base.texture = load(RoseGarden._get_file_path()+"Button/Base/Base"+color+".svg")
		"Left":
			base.texture = load(RoseGarden._get_file_path()+"Button/BaseLeft/Base"+color+".svg")
		"Right":
			base.texture = load(RoseGarden._get_file_path()+"Button/BaseRight/Base"+color+".svg")
		"Both":
			base.texture = load(RoseGarden._get_file_path()+"Button/BaseBoth/Base"+color+".svg")

func _update_themes():
	label.theme = load(RoseGarden._theme_path+"Secondary.tres")
