extends Control

@onready var title: RGText = $HBoxContainer/RGText
@onready var reset: RGButton = $HBoxContainer/VBoxContainer/Reset

@warning_ignore("unused_signal")
signal value_changed(option_id,new_value)
var first_value_set:bool = false

func set_value(_value:bool):
	pass

func get_value():
	return true

func interact():
	reset.press()

func _on_reset_hovered() -> void:
	reset.set_color("Red")

func _on_reset_de_hovered() -> void:
	reset.set_color("Gray")

func _on_reset_pressed() -> void:
	for command in CommandBar._client.commands:
		CommandBar._client.command_points[command] = 0
	Debug.log("Search points reset","core.command_bar")
	CommandBar._client.save()
