extends Control
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var progress: TextureProgressBar = $TextureRect/VBoxContainer/TextureProgressBar
@onready var title: Label = $TextureRect/MarginContainer/VBoxContainer/Label
@onready var desc: Label = $TextureRect/MarginContainer/VBoxContainer/Label2

func _ready() -> void:
	progress.modulate = Color(rtv.settings["accent_color"])
	title.text = rtv.pop_up_name
	desc.text = rtv.pop_up_desc
	animator.play("In")
	await animator.animation_finished
	animator.play("Progress")
	await animator.animation_finished
	animator.play("Out")
	await animator.animation_finished
	queue_free()


func _on_button_pressed() -> void:
	rtv.popup_clicked = true
	animator.play("Out")
	await animator.animation_finished
	queue_free()
