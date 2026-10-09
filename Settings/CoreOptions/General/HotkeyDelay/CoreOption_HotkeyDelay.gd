extends Control

@onready var text_field: RGTextField = $HBoxContainer/RGTextField
@onready var title: RGText = $HBoxContainer/RGText
@onready var down: RGButton = $HBoxContainer/HBoxContainer/Down
@onready var up: RGButton = $HBoxContainer/HBoxContainer/Up

var number:float = 0
var interact_up:bool = true
signal value_changed(option_id,new_value)

func set_value(value:float):
	number = value
	print(value)
	text_field.set_text(str(number)+"s")

func get_value():
	return number

func interact():
	if interact_up:
		_on_up_pressed()
	else:
		_on_down_pressed()
	if number == 10:
		interact_up = false
	elif number == 0.5:
		interact_up = true
	value_changed.emit(name,number)

func _on_down_pressed() -> void:
	if number == 0.5:
		return 
	if number == 1:
		down.set_disabled(true)
	number -= 0.5
	text_field.set_text(str(number)+"s")
	up.set_disabled(false)
	value_changed.emit(name,number)

func _on_up_pressed() -> void:
	if number == 10:
		return 
	if number == 9.5:
		up.set_disabled(true)
	number += 0.5
	text_field.set_text(str(number)+"s")
	down.set_disabled(false)
	value_changed.emit(name,number)
