extends Control

@onready var text_field: RGTextField = $HBoxContainer/RGTextField
@onready var title: RGText = $HBoxContainer/RGText
@onready var down: RGButton = $HBoxContainer/HBoxContainer/Down
@onready var up: RGButton = $HBoxContainer/HBoxContainer/Up

var number: int = 0
var interact_up: bool = true
signal value_changed(option_id, new_value)

func set_value(value: int):
	number = value
	text_field.set_text(" "+str(number))

func get_value():
	return number

func interact():
	if interact_up:
		_on_up_pressed()
	else:
		_on_down_pressed()
	if number == 10:
		interact_up = false
	elif number == 1:
		interact_up = true
	value_changed.emit(name, number)

func _on_down_pressed() -> void:
	if number == 1:
		return
	if number == 2:
		down.set_disabled(true)
	number -= 1
	text_field.set_text(" "+str(number))
	up.set_disabled(false)
	value_changed.emit(name, number)

func _on_up_pressed() -> void:
	if number == 10:
		return
	if number == 9:
		up.set_disabled(true)
	number += 1
	text_field.set_text(" "+str(number))
	down.set_disabled(false)
	value_changed.emit(name, number)
