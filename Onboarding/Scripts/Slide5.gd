
extends VBoxContainer
@onready var onboarding: Control = $"../../../../../../../.."
@onready var disable_animations: Control = $VBoxContainer/AccOptions/Control
@onready var increase_contrast: Control = $VBoxContainer/AccOptions/Control2
@onready var symbol_indicators: Control = $VBoxContainer/AccOptions/Control3


func _on_onboarding_next_slide_selected() -> void:
	if onboarding.slide == 6:
		if disable_animations.selected:
			Settings.set_option_value("core.accessibility/disable_animations",true)
		if increase_contrast.selected:
			Settings.set_option_value("core.accessibility/increase_contrast",true)
		if symbol_indicators.selected:
			Settings.set_option_value("core.accessibility/symbol_indicators",true)
