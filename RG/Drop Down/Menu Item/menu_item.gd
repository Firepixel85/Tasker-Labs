extends Control

@onready var tick: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/TextureRect
@onready var text: Label = $MarginContainer/VBoxContainer/HBoxContainer/Label

var id := 0
var option_name := "Test"
var selected := false
var highlighted := false
var manager:Control

func _update():
	text.text = option_name
	var filename = "res://RG/Drop Down/"
	if selected:
		filename += "Selected"
	else:
		filename += "Unselected"
	
	if highlighted:
		filename += "Highlighted"
	
	filename += ".png"
	tick.texture = load(filename)
	

func _ready() -> void:
	_update()
