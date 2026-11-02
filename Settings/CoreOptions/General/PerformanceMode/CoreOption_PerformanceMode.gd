extends Control

@onready var toggle: RGToggle = $HBoxContainer/VBoxContainer/Toggle
@onready var title: RGText = $HBoxContainer/RGText

signal value_changed(option_id,new_value)
var first_value_set:bool = false

func set_value(value:bool):
	toggle.set_state(value,true)
	toggle._update()

func get_value():
	return toggle.is_toggled

func _on_toggled(toggled_on: bool) -> void:
	value_changed.emit(name,toggled_on)

func _ready() -> void:
	toggle.set_color(Settings.get_option_value("core.appearance/accent_color"))
	toggle.set_accessible(Settings.get_option_value("core.accessibility/symbol_indicators"))
	Settings.setting_changed.connect(_update_color)

func _update_color(option_path,new_value):
	if option_path == "core.appearance/accent_color":
		toggle.set_color(new_value)

func interact():
	toggle.toggle()

var tooltip_timer:Timer
var tooltip_shown:bool = false
func _on_mouse_entered() -> void:
	tooltip_timer = Timer.new()
	add_child(tooltip_timer)
	tooltip_timer.start(1)
	tooltip_timer.timeout.connect(_show_tooltip)
	
func _show_tooltip():
	if tooltip_shown:
		return
	tooltip_shown = true
	var tooltip = RGTooltip.new()
	tooltip.set_text("Reduces the processing power Tasker uses")
	RoseGarden.create_tooltip(tooltip,get_global_mouse_position())

func _on_mouse_exited() -> void:
	tooltip_shown = false
	tooltip_timer.timeout.disconnect(_show_tooltip)
	tooltip_timer.queue_free()
	RoseGarden.clear_tooltips()
