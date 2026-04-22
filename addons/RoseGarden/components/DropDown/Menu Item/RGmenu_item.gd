extends Control

@onready var tick: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var text: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label
@onready var button: Button = $Button
@onready var min_size_setter: VBoxContainer = $MarginContainer/VBoxContainer
signal _updated
signal _highlighted(id:int)
var id := 0
var option_name := "Test"
var selected := false
var highlighted := false
var manager:RGDropDown = RGDropDown.new()

func _update():
	custom_minimum_size.x = min_size_setter.size.x+6
	text.text = option_name
	if manager.selected == id:
		selected = true
	else:
		selected = false

	var filename = RoseGarden._file_path+"DropDown/"
	if selected:
		filename += "Selected"
	else:
		filename += "Unselected"

	if highlighted:
		filename += "Highlighted"

	filename += ".svg"
	tick.texture = load(filename)
	button.size=size
	_updated.emit()


func _ready() -> void:
	get_parent()._highlighted.connect(change_highlight)
	RoseGarden.custom_textures_changed.connect(_update)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update()
	_update_themes()



func _pressed() -> void:
	manager.select(id)
	manager._close()


func _on_mouse_entered() -> void:
	highlighted = true
	_highlighted.emit(id)
	_update()

func _on_mouse_exited() -> void:
	manager.selection.visible = false
	highlighted = false
	_update()

func change_highlight(new_id:int):
	if id == new_id:
		return
	highlighted = false
	_update()

func _update_themes():
	text.theme = RoseGarden.Themes.Secondary
