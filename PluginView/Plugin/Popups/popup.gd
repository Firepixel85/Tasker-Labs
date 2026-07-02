extends Control

@onready var close: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Close

func _on_close_pressed() -> void:
	Popups.clear_popup()

	
