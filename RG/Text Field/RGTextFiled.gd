@tool
extends Control
class_name RGTextField
@onready var text_container: MarginContainer = $NinePatchRect/MarginContainer
@onready var container: NinePatchRect = $NinePatchRect
@onready var line_edit: LineEdit = $MarginContainer/LineEdit
@onready var label: Label = $NinePatchRect/MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var mask: NinePatchRect = $NinePatchRect2
@onready var hint_text: Label = $MarginContainer2/VBoxContainer/HBoxContainer/NinePatchRect/MarginContainer/Label
@onready var hint_texture: NinePatchRect = $MarginContainer2/VBoxContainer/HBoxContainer/NinePatchRect
@onready var hint_container: MarginContainer = $MarginContainer2

@export var placeholder_text:String = ""
@export var editable:bool = true
@export var emoji_menu_enabled:bool = true
@export var caret_blink:bool = true
@export var show_hint:bool = false
@export var hint := "⌘K"
@export var secret := false

var text:String
signal text_changed(new_text:String)

func get_text():
	return label.text

func set_text(new_text:String):
	line_edit.text = new_text
	_update()
	text_changed.emit(new_text)
	return OK

func set_hint(new_hint:String):
	hint = new_hint
	_update()
	return OK

func _update():
	hint_text.text = hint
	container.size.x = size.x
	hint_container.size.x = size.x
	mask.size.x = size.x
	line_edit.get_parent().size.x = size.x
	hint_texture.custom_minimum_size.x = hint_text.size.x + 16
	line_edit.secret = secret
	if label.size.x > size.x-32:
		text_container.layout_direction = Control.LAYOUT_DIRECTION_RTL
	else:
		text_container.layout_direction = Control.LAYOUT_DIRECTION_INHERITED
	if line_edit.has_focus():
		create_tween().tween_property(hint_container,"modulate",Color(0,0,0,0),0.1).set_trans(Tween.TRANS_BOUNCE)
	else:
		create_tween().tween_property(hint_container,"modulate",Color(1,1,1,1),0.1).set_trans(Tween.TRANS_BOUNCE)
	if show_hint:
		hint_container.visible = true
	else:
		hint_container.visible = false
	_mirror_to_line_edit()
	text = label.text

func _process(_delta: float) -> void:
	label.text = line_edit.text
	if secret:
		var text_array = line_edit.text.split("")
		var new_text = ""
		for character in text_array:
			new_text += "*"
		if Array(text_array) == [""]:
			new_text = ""
		label.text = new_text
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	_update()
	await get_tree().create_timer(0.1).timeout #Needs to update two time with a small delay to scale the hint container correctly
	_update()

func _on_text_changed(_new_text: String) -> void:
	_update()
	text_changed.emit(_new_text)

func _on_focus_exited() -> void:
	_update()

func _mirror_to_line_edit():
	line_edit.placeholder_text = placeholder_text
	line_edit.editable = editable
	line_edit.emoji_menu_enabled = emoji_menu_enabled
	line_edit.caret_blink = caret_blink


func _on_mouse_entered() -> void:
	modulate = Colors.COLOR_HOVERED


func _on_mouse_exited() -> void:
	modulate = Colors.COLOR_NORMAL

func clear():
	line_edit.clear()
	_update()
