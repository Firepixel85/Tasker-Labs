extends Control
@onready var text: RichTextLabel = $MarginContainer/TextEdit
@onready var command_input: RGTextField = $MarginContainer2/VBoxContainer/MarginContainer/HBoxContainer/RGTextField
@onready var command_send: RGButton = $MarginContainer2/VBoxContainer/MarginContainer/HBoxContainer/RGButton

@onready var log_toggle: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/ToggleLogs
@onready var log_count: RGText = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText

@onready var warn_toggle: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/ToggleWarns
@onready var warn_count: RGText = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText2

@onready var error_toggle: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/ToggleErrors
@onready var error_count: RGText = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText3

@onready var clear_button: RGButton = $MarginContainer2/VBoxContainer/HBoxContainer/RGContainer/MarginContainer/VBoxContainer/Clear

var show_logs:bool = true
var show_warns:bool = true
var show_errors:bool = true

func _ready() -> void:
	Debug.logs_changed.connect(_update_logs)

func _update_logs():
	text.clear()
	for i in Debug.get_logs().size():
		match Debug.log_type[i]:
			"Info":
				if show_logs:
					text.append_text(Debug.get_logs()[i])
					text.newline()
			"Warn":
				if show_warns:
					text.append_text("[color=FBC600]"+Debug.get_logs()[i]+" [/color]")
					text.newline()
			"Error":
				if show_errors:
					text.append_text("[color=D72D2C]"+Debug.get_logs()[i]+" [/color]")
					text.newline()
		
	log_count.set_text(str(Debug.log_count))
	warn_count.set_text(str(Debug.warn_count))
	error_count.set_text(str(Debug.error_count))
	

func _on_toggle_logs_pressed() -> void:
	if show_logs:
		show_logs = false
		log_toggle.set_color("Gray")
	else:
		show_logs = true
		log_toggle.set_color("Yellow")
	_update_logs()

func _on_toggle_warns_pressed() -> void:
	if show_warns:
		show_warns = false
		warn_toggle.set_color("Gray")
	else:
		show_warns = true
		warn_toggle.set_color("Orange")
	_update_logs()

func _on_toggle_errors_pressed() -> void:
	if show_errors:
		show_errors = false
		error_toggle.set_color("Gray")
	else:
		show_errors = true
		error_toggle.set_color("Red")
	_update_logs()

func _on_clear_pressed() -> void:
	Debug.clear_logs()
	_update_logs()
