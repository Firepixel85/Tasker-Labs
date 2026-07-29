extends Control

@onready var title: RGText = $HBoxContainer/RGText
@onready var reset: RGButton = $HBoxContainer/VBoxContainer/Restart

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
	reset.color = "Gray"
	Data.save_to("onboarding_complete",false,"Core/UpdateData")
	Data.save_file("Core/UpdateData")
	Main.change_view("onboarding")
