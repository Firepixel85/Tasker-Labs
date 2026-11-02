extends Control

@onready var close: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Close
@onready var flame: Control = $RGContainer/MarginContainer/VBoxContainer/CenterContainer/Flame


func _on_close_pressed() -> void:
	Popups.clear_popup()
	flame.play("Fade")

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		close.press()

func _ready() -> void:
	flame.set_new_size('Small')
	flame.set_color("Red")
	await get_tree().create_timer(0.2).timeout
	flame.play("GoalTrans")
