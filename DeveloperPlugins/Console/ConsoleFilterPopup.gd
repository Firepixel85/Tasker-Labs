extends Control
@onready var logger_ddm: RGDropDown = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/LoggerDDM
@onready var apply: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Apply
@onready var exclude_logger: RGToggle = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ExcludeLogger
@onready var exclude_logger_toggle: RGToggle = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer2/VBoxContainer/ExcludeLogger

var console: Control
var logger_ids : = {}
var ddm_indexes : = {}

func setup(loggers: Array, selected: String):
	apply.set_color(Settings.get_option_value("core.appearance/accent_color"))
	exclude_logger_toggle.set_color(Settings.get_option_value("core.appearance/accent_color"))
	logger_ddm.add_item("No Filter", 0)
	ddm_indexes["No Filter"] = 0
	exclude_logger_toggle.set_state(console.logger_exclude, true)
	for i in range(loggers.size()):
		logger_ids[Main.get_process_name(loggers[i])] = loggers[i]
		ddm_indexes[loggers[i]] = i+1
		logger_ddm.add_item(Main.get_process_name(loggers[i]), i+1)
	logger_ddm.canvas_layer_index = 3
	logger_ddm.select(ddm_indexes[selected])

func _on_apply_pressed() -> void:
	if logger_ddm.get_selected() == 0:
		console.logger_filter = []
		console.logger_exclude = false
	else:
		console.logger_filter = [logger_ids[logger_ddm.get_selected_item()]]
		console.logger_exclude = exclude_logger.is_toggled
	console._update_logs()
	Popups.clear_popup()

func _on_cancel_pressed() -> void:
	Popups.clear_popup()

func _on_clear_pressed() -> void:
	logger_ddm.select(0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		apply.press()
	if Input.is_action_just_pressed("1") and Input.is_key_pressed(KEY_SHIFT):
		logger_ddm._open()
	if Input.is_action_just_pressed("2") and Input.is_key_pressed(KEY_SHIFT):
		exclude_logger_toggle.toggle()
