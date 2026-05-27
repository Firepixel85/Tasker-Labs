extends Control

@onready var create_event: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/CreateEvent/CreateEvent
@onready var remove_event: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/RemoveEvent/RemoveEvent

const ID = "com.rosepen.test"

func _on_create_event_pressed() -> void:
	create_event.set_disabled(true)
	remove_event.set_disabled(false)
	#Events.add_event("com.rosepen.test",load("res://DeveloperPlugins/Test/test_event.tscn"),Icons.CHECKBOOK)
	Events.add_event(ID,load("res://DeveloperPlugins/Test/test_event.tscn"),load("res://DeveloperPlugins/Test/icon.png"))

func _on_remove_event_pressed() -> void:
	create_event.set_disabled(false)
	remove_event.set_disabled(true)
	Events.remove_event(ID)

func _ready() -> void:
	Settings.setting_changed.connect(_update_buttons)
	create_event.set_color(Settings.get_option_value("core.appearance/accent_color"))
	remove_event.set_color(Settings.get_option_value("core.appearance/accent_color"))

func _update_buttons(option_path,new_value):
	if option_path == "core.appearance/accent_color":
		create_event.set_color(new_value)
		remove_event.set_color(new_value)
