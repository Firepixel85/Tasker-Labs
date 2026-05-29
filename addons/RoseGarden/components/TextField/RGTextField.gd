@tool
extends Control
class_name RGTextField
@onready var container: NinePatchRect = $NinePatchRect
@onready var line_edit: LineEdit = $MarginContainer/LineEdit
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
@export var incorrect:bool = false

var text:String = ""
signal text_changed(new_text:String)
signal text_submitted(new_text:String)
signal edit_exited
signal edit_entered

func get_text():
	return line_edit.text

func set_text(new_text:String):
	line_edit.text = new_text
	_update()
	text_changed.emit(new_text)
	return OK

func set_hint(new_hint:String):
	hint = new_hint
	_update()
	return OK

func set_inccorrect(is_incorrect:bool):
	incorrect = is_incorrect
	_update()
	return OK

func edit():
	line_edit.grab_focus()
	line_edit.edit()
	return OK

##############
#### STOP #### Here begins private functions that should never be called by your code
##############

func _update():
	hint_text.text = hint
	container.size.x = size.x
	hint_container.size.x = size.x
	line_edit.get_parent().size.x = size.x
	hint_texture.custom_minimum_size.x = hint_text.size.x + 16
	line_edit.secret = secret

	if line_edit.has_focus():
		create_tween().tween_property(hint_container,"modulate",Color(0,0,0,0),0.1*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_BOUNCE)
	else:
		create_tween().tween_property(hint_container,"modulate",Color(1,1,1,1),0.1*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_BOUNCE)
	if show_hint:
		hint_container.visible = true
	else:
		hint_container.visible = false

	if incorrect:
		line_edit.modulate = RoseGarden.Colors.RED_HIGHLIGHT
		container.texture = preload("res://addons/RoseGarden/components/TextField/ContainerIncorrect.svg")
	else:
		line_edit.modulate = Color(1,1,1)
		container.texture = preload("res://addons/RoseGarden/components/TextField/Container.svg")
	if secret:
		line_edit.get_parent().size.y = 74
	else:
		line_edit.get_parent().size.y = 60

	_mirror_to_line_edit()
	line_edit.caret_blink = !RoseGarden.Accessibility.get_disable_animations()

func _process(_delta: float) -> void:
	if secret:
		if line_edit.text == "":
			line_edit.add_theme_font_size_override("font_size",20)
		else:
			line_edit.add_theme_font_size_override("font_size",30)
	else:
		line_edit.add_theme_font_size_override("font_size",20)

	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update_themes()
	_update()
	await get_tree().create_timer(0.2).timeout
	_update()

func _on_text_changed(_new_text: String) -> void:
	_update()
	text_changed.emit(_new_text)

func _mirror_to_line_edit():
	line_edit.placeholder_text = placeholder_text
	line_edit.editable = editable
	line_edit.emoji_menu_enabled = emoji_menu_enabled
	line_edit.caret_blink = caret_blink

func _on_mouse_entered() -> void:
	modulate = RoseGarden.Colors.COLOR_HOVERED

func _on_mouse_exited() -> void:
	modulate = RoseGarden.Colors.COLOR_NORMAL

func clear():
	line_edit.clear()
	_update()

func _on_line_edit_text_submitted(new_text: String) -> void:
	text_submitted.emit(new_text)

func _update_themes():
	line_edit.theme = RoseGarden.Themes.Secondary
	hint_text.theme = RoseGarden.Themes.Secondary

func _on_focus_exited() -> void:
	edit_entered.emit()

func _on_focus_entered() -> void:
	edit_entered.emit()
