extends Control

var plugin_id:String
@onready var uninstall: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Uninstall

func _on_cancel_pressed() -> void:
	Popups.remove_popup()

func _on_uninstall_pressed() -> void:
	Popups.remove_popup()

func _process(_delta: float) -> void: 
	if Input.is_action_just_pressed("ui_confirm"):
		uninstall.press()
