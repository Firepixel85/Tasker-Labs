extends Control
@onready var text: RichTextLabel = $MarginContainer/TextEdit
@onready var command_input: RGTextField = $MarginContainer2/VBoxContainer/MarginContainer/HBoxContainer/RGTextField
@onready var command_send: RGButton = $MarginContainer2/VBoxContainer/MarginContainer/HBoxContainer/RGButton

@onready var log_toggle: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGButton
@onready var log_count: RGText = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText

@onready var warn_toggle: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGButton2
@onready var warn_count: RGText = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText2

@onready var error_toggle: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGButton3
@onready var error_count: RGText = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText3

@onready var clear_button: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGButton4

func _ready() -> void:
	Debug.logs_changed.connect(_update_logs)

func _update_logs():
	text.clear()
	for i in Debug.get_logs().size():
		match Debug.log_type[i]:
			"Info":
				text.append_text(Debug.get_logs()[i])
				text.newline()
			"Warn":
				text.append_text("[color=FBC600]"+Debug.get_logs()[i]+" [/color]")
				text.newline()
			"Error":
				text.append_text("[color=D72D2C]"+Debug.get_logs()[i]+" [/color]")
				text.newline()
		
	log_count.set_text(str(Debug.log_count))
	warn_count.set_text(str(Debug.warn_count))
	error_count.set_text(str(Debug.error_count))
