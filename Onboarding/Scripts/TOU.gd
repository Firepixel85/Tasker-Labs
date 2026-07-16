extends CenterContainer

@onready var checkbox_text: Label = $RGContainer/MarginContainer/VBoxContainer/CheckboxContainer/CenterContainer/Checkbox/HBoxContainer/CheckboxText
@onready var checkbox_texture: TextureRect = $RGContainer/MarginContainer/VBoxContainer/CheckboxContainer/CenterContainer/Checkbox/HBoxContainer/CheckboxTexture
@onready var next: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Next
@onready var onboarding: Control = $"../.."

var tou_accepted

func _on_checkbox_mouse_entered() -> void:
	checkbox_text.modulate = Color("f5f5f5")
	if tou_accepted:
		checkbox_texture.texture = load("res://Onboarding/Textures/Checkbox/SelectedHighlighted.svg")
	else:
		checkbox_texture.texture = load("res://Onboarding/Textures/Checkbox/UnselectedHighlighted.svg")

func _on_checkbox_mouse_exited() -> void:
	checkbox_text.modulate = Color("acacac")
	if tou_accepted:
		checkbox_texture.texture = load("res://Onboarding/Textures/Checkbox/Selected.svg")
	else:
		checkbox_texture.texture = load("res://Onboarding/Textures/Checkbox/Unselected.svg")

func _on_checkbox_pressed() -> void:
	if tou_accepted:
		tou_accepted = false
		next.disabled = true
	else:
		tou_accepted = true
		next.disabled = false
	_on_checkbox_mouse_entered()

func _on_next_pressed() -> void:
	onboarding.next_slide()
