extends Control

@onready var toggle: RGToggle = $HBoxContainer/VBoxContainer/Toggle
@onready var title: RGText = $HBoxContainer/RGText
@onready var colors: HBoxContainer = $HBoxContainer/HBoxContainer

signal value_changed(option_id,new_value)

var current_value

func set_value(value:String):
	current_value = value
	for color in colors.get_children():
		color.select(value)

func get_value():
	return current_value

func _on_selected(new_color):
	value_changed.emit(name,new_color)
