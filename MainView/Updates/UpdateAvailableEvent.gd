extends Control

func _on_button_pressed() -> void:
	Popups.create_popup(load("res://MainView/Updates/UpdateAvailablePopup.tscn"))
