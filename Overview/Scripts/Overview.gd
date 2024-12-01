extends Control

@onready var instance1: VBoxContainer = $MarginContainer/Control/TextureRect/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Control/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var instance2: VBoxContainer = $MarginContainer/Control/TextureRect/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/TextureRect2/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var score: TextureProgressBar = $MarginContainer/Control/TextureRect/MarginContainer/HBoxContainer/Control/VBoxContainer/Control/Score/Control/TextureProgressBar

#Smooth Scrolling:
@onready var scroll_container: SmoothScrollContainer = $MarginContainer/Control/TextureRect/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Control/TextureRect/MarginContainer/VBoxContainer/ScrollContainer
@onready var scroll_container_done: SmoothScrollContainer = $MarginContainer/Control/TextureRect/MarginContainer/HBoxContainer/VBoxContainer2/HBoxContainer/TextureRect2/MarginContainer/VBoxContainer/ScrollContainer
var profile = {"smooth":load("res://Scroll Profiles/Smooth.tres"),"standard":load("res://Scroll Profiles/Standard.tres")}
func _ready() -> void:
	visible = false

func _on_new_task(id: int) -> void:
	instance1.add_task(id)
	instance2.add_task(id)
	score.animate_value(true)


func _on_page_changed(page: Variant) -> void:
	if page == "overview":
		var tween = get_tree().create_tween()
		score.animate_value()


func _on_changed_page(page: String) -> void:
	if page == "overview":
		var tween = get_tree().create_tween()
		score.animate_value(false)
