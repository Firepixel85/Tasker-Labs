extends Control

var plugin_id:String
@onready var uninstall: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Uninstall
@onready var cancel: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Cancel
@onready var rg_container: Control = $RGContainer

func _on_cancel_pressed() -> void:
	Popups.remove_popup()

func _on_uninstall_pressed() -> void:
	Popups.remove_popup()

func _process(_delta: float) -> void: 
	rg_container._update()
	if Input.is_action_just_pressed("ui_confirm"):
		uninstall.press()

func _on_cancel_hovered() -> void:
	await get_tree().create_timer(1).timeout
	if !cancel.is_hovered():
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Cancel")
	tooltip.set_show_keybind(true)
	tooltip.set_keybind("Esc")
	RoseGarden.create_tooltip(tooltip,get_global_mouse_position())

func _clear_tooltips() -> void:
	RoseGarden.clear_tooltips()

func _on_uninstall_hovered() -> void:
	await get_tree().create_timer(1).timeout
	if !uninstall.is_hovered():
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Uninstall")
	tooltip.set_show_keybind(true)
	tooltip.set_keybind("⌘⏎")
	RoseGarden.create_tooltip(tooltip,get_global_mouse_position())
