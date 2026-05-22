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

func interact():
	if current_value+1>colors.get_child_count():
		current_value = colors.get_child(0).color
	else:
		for i in colors.get_child_count():
			if colors.get_child(i).color == current_value:
				current_value = colors.get_child(i+1)
				break
			else:
				pass
	value_changed.emit(name,current_value)
