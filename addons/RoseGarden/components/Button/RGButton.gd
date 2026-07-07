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
@export_enum("Gray","White","Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple") var color := "Gray":
	set(new_value):
		if !Engine.is_editor_hint() and RoseGarden.Colors.verify_color(new_value,true) != OK:
			return
		color = new_value
		if base != null:
			base.texture = load(RoseGarden._get_file_path()+"Button/Base"+connection+"/Base"+color+".svg")
		if label == null:
			return
		if color == "White" or ((color == "Yellow" or color == "Green" or color == "Teal") and RoseGarden.Accessibility.get_increase_contrast()):
			label.modulate = Color(0,0,0)
			texture.modulate = Color(0,0,0)
		else:
			label.modulate = Color(1,1,1)
			texture.modulate = Color(1,1,1)
@export var text := "Button":
	set(new_value):
		text = new_value
		_update()
@export var icon:Texture2D:
	set(new_value):
		icon = new_value
		_update()
@export_enum("None","Left","Right","BothHorizontal","Up","Down","BothVertical") var connection := "None":
	set(new_value):
		connection = new_value
		_update()

@export_category("Button Controls")
@export var disabled:bool = false:
	set(new_value):
		disabled = new_value
		if button == null:
			return
		button.disabled = disabled
		_update()
@export var toggle_mode:bool = false:
	set(new_value):
		toggle_mode = new_value
		_update()

@export_category("Tooltip")
@export var show_tooltip:bool = false
@export var tooltip_display_text:String = "Tooltip"
@export var tooltip_delay:float = 1.0
@export var show_keybind:bool = false
@export var keybind_text:String = "⌘K"

signal button_down
signal button_up
signal pressed
signal toggled(toggled_on:bool)
signal hovered
signal de_hovered

var _hovered:bool = false
var is_pressed:bool = false

func set_color(new_color:String):
	if !Engine.is_editor_hint() and RoseGarden.Colors.verify_color(new_color,true) != OK:
		return ERR_INVALID_PARAMETER
	color = new_color
	base.texture = load(RoseGarden._get_file_path()+"Button/Base"+connection+"/Base"+color+".svg")
	if color == "White" or ((color == "Yellow" or color == "Green" or color == "Teal") and RoseGarden.Accessibility.get_increase_contrast()):
		label.modulate = Color(0,0,0)
		texture.modulate = Color(0,0,0)
	else:
		label.modulate = Color(1,1,1)
		texture.modulate = Color(1,1,1)
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

func set_disabled(is_disabled:bool):
	disabled = is_disabled
	button.disabled = disabled
	_update()

func grab_focus(bool = true) -> void:
	button.grab_focus(bool)
	button.grab_click_focus()

##############
#### STOP #### Here begin private functions that should never be called by your code
##############

func _process(_delta: float) -> void:
	if base.size.x != size.x: #Update desync failsafe
		_update()


func _update():
	if label == null:
		return
	label.text = text
	texture.texture = icon
	base.texture = load(RoseGarden._get_file_path()+"Button/Base"+connection+"/Base"+color+".svg")
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
	button.disabled = disabled
	if disabled:
		modulate = RoseGarden.Colors.COLOR_DISABLED
	else:
		modulate = RoseGarden.Colors.COLOR_NORMAL
	match connection:
		"None","BothHorizontal","BothVertical":
			pivot_offset = size/2
		"Left":
			pivot_offset = Vector2(0,size.y/2)
		"Right":
			pivot_offset = Vector2(size.x,size.y/2)
		"Up":
			pivot_offset = Vector2(size.x/2,0)
		"Down":
			pivot_offset = Vector2(size.x/2,size.y)
	set_color(color)

func _ready() -> void:
	set_color(color)
	_update()
	RoseGarden.custom_textures_changed.connect(_update)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	RoseGarden.update_components.connect(_update)
	_update_themes()
	await get_tree().process_frame
	_update()

func _on_button_down() -> void:
	button_down.emit()
	if !is_pressed and toggle_mode:
		is_pressed = true
	elif  is_pressed and toggle_mode:
		is_pressed = false
		return
	if disabled:
		pass
	else:
		modulate = RoseGarden.Colors.COLOR_PRESSED
	if RoseGarden.Accessibility.get_disable_animations() or !RoseGarden.Animations.buttonPress:
		return
	var tween = create_tween()
	if connection == "BothHorizontal":
		tween.tween_property(self,"scale",Vector2(1,0.9),0.1).set_trans(Tween.TRANS_CUBIC)
	elif connection == "BothVertical":
		tween.tween_property(self,"scale",Vector2(0.9,1),0.1).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(self,"scale",Vector2(0.95,0.95),0.1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	return

func _on_button_up() -> void:
	button_up.emit()
	if is_pressed and toggle_mode:
		return
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
	if RoseGarden.Accessibility.get_disable_animations():
		return
	var tween = create_tween()
	tween.tween_property(self,"scale",Vector2(1,1),0.1).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	return

func _on_pressed() -> void:
	pressed.emit()

func _on_toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)

func _on_mouse_entered() -> void:
	_hovered = true
	hovered.emit()
	if disabled:
		modulate = RoseGarden.Colors.COLOR_DISABLED_HOVERED
	else:
		modulate = RoseGarden.Colors.COLOR_HOVERED
	if toggle_mode and is_pressed:
		modulate = RoseGarden.Colors.COLOR_PRESSED
	if !show_tooltip:
		return
	await get_tree().create_timer(tooltip_delay).timeout
	if is_hovered():
		var tooltip = RGTooltip.new()
		tooltip.set_text(tooltip_display_text)
		if show_keybind:
			tooltip.set_keybind(keybind_text)
		RoseGarden.create_tooltip(tooltip,get_global_mouse_position())

func _on_mouse_exited() -> void:
	_hovered = false
	de_hovered.emit()
	if disabled:
		modulate = RoseGarden.Colors.COLOR_DISABLED
	else:
		modulate = RoseGarden.Colors.COLOR_NORMAL
	if toggle_mode and is_pressed:
		modulate = RoseGarden.Colors.COLOR_PRESSED
	RoseGarden.clear_tooltips()

func _update_themes():
	label.theme = load(RoseGarden._theme_path+"Secondary.tres")
