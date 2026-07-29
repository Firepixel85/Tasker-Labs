extends Control
@onready var button: Button = $Button
@onready var checkbox: TextureRect = $HBoxContainer/Checkbox

var selected = false
func _mouse_entered():
	if selected:
		checkbox.texture = load("res://Onboarding/Textures/Checkbox/SelectedHighlighted.svg")
	else:
		checkbox.texture = load("res://Onboarding/Textures/Checkbox/UnselectedHighlighted.svg")

func _mouse_exited():
	if selected:
		checkbox.texture = load("res://Onboarding/Textures/Checkbox/Selected.svg")
	else:
		checkbox.texture = load("res://Onboarding/Textures/Checkbox/Unselected.svg")

func _pressed():
	selected = !selected
	_mouse_entered()

func _ready() -> void:
	button.mouse_entered.connect(_mouse_entered)
	button.mouse_exited.connect(_mouse_exited)
	button.pressed.connect(_pressed)
