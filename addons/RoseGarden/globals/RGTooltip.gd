extends Node
class_name RGTooltip

var text:String
var show_keybind:bool
var keybind:String

func _init() -> void:
	text = ""
	show_keybind = false
	keybind = ""

func set_text(new_text:String):
	text = new_text
	return OK

func set_show_keybind(show:bool):
	show_keybind = show
	return OK

func set_keybind(new_keybind:String):
	keybind = new_keybind
	return OK
