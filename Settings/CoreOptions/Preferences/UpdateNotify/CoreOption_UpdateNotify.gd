extends Control

@onready var toggle: RGToggle = $HBoxContainer/VBoxContainer/Toggle
@onready var title: RGText = $HBoxContainer/RGText

signal value_changed(option_id,new_value)

func set_value(value:bool):
	toggle.set_state(value)

func get_value():
	return toggle.is_toggled

func _on_toggled(toggled_on: bool) -> void:
	value_changed.emit(name,toggled_on)

func _ready() -> void:
	toggle.set_color(Settings.get_option_value("core.appearance/accent_color"))
	Settings.setting_changed.connect(_update_color)

func _update_color(option_path,new_value):
	if option_path == "core.appearance/accent_color":
		toggle.set_color(new_value)
