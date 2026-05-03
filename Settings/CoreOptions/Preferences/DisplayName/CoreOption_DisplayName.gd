extends Control

@onready var text_field: RGTextField = $HBoxContainer/RGTextField
@onready var title: RGText = $HBoxContainer/RGText

signal value_changed(option_id,new_value)

func set_value(value:String):
	text_field.set_text(value)

func get_value():
	return text_field.get_text()

func _on_text_changed(new_text: String) -> void:
	value_changed.emit(name,new_text)
