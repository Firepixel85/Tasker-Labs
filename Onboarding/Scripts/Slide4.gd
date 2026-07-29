extends VBoxContainer
@onready var button_container: HBoxContainer = $CenterContainer/VBoxContainer/HBoxContainer
@onready var onboarding: Control = $"../../../../../../../.."

var selected_color:String = "Purple"

func _color_selected(color:String):
	selected_color = color
	for button in button_container.get_children():
		if button.color == color:
			continue
		button.selected = false
		button._mouse_exited()
	
func _ready() -> void:
	for button in button_container.get_children():
		button.selected_color.connect(_color_selected)
	button_container.get_child(6)._pressed()

func _on_onboarding_next_slide_selected() -> void:
	if onboarding.slide == 5:
		Settings.set_option_value("core.appearance/accent_color",selected_color)
