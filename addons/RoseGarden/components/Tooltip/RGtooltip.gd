@tool
extends Control
@onready var text_container: NinePatchRect = $HBoxContainer/TextContainer
@onready var text_text: RGText = $HBoxContainer/TextContainer/CenterContainer/Text
@onready var keybind_container: NinePatchRect = $HBoxContainer/KeybindContainer
@onready var keybind_text: RGText = $HBoxContainer/KeybindContainer/CenterContainer/KeybindText

@export var text:String = "Text"
@export var show_keybind:bool = false
@export var keybind:String = "⌘K"

func set_text(new_text:String):
	text = new_text
	_update()
	return OK

func set_show_keybind(show:bool):
	show_keybind = show
	_update()
	return OK

func set_keybind(new_keybind:String):
	keybind = new_keybind
	_update()
	return OK

##############
#### STOP #### Here begin private functions that should never be called by your code
##############

func _update():
	text_text.set_text(text)
	keybind_text.set_text(keybind)
	await get_tree().process_frame
	text_container.custom_minimum_size.x = text_text.size.x + 20
	keybind_container.custom_minimum_size.x = keybind_text.size.x + 20
	keybind_container.visible = show_keybind

func _update_textures():
	text_container.texture = load(RoseGarden._get_file_path()+"Tooltip/Container.svg")
	keybind_container.texture = load(RoseGarden._get_file_path()+"Tooltip/Container.svg")

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	_update()
	await get_tree().process_frame
	_update()
