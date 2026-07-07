extends Control
@onready var text: RichTextLabel = $MarginContainer/HBoxContainer/TextEdit
@onready
var command_input: RGTextField = $MarginContainer2/VBoxContainer/MarginContainer/HBoxContainer/RGTextField
@onready
var command_send: RGButton = $MarginContainer2/VBoxContainer/MarginContainer/HBoxContainer/RGButton

@onready
var log_toggle: RGButton = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/ToggleLogs
@onready
var log_count: RGText = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText

@onready
var warn_toggle: RGButton = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/ToggleWarns
@onready
var warn_count: RGText = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText2

@onready
var error_toggle: RGButton = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/ToggleErrors
@onready
var error_count: RGText = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/RGText3

@onready
var clear_button: RGButton = $MarginContainer/HBoxContainer/VBoxContainer/RGContainer/MarginContainer/VBoxContainer/Clear

var show_logs: bool = true
var show_warns: bool = true
var show_errors: bool = true

var logger_filter = []
var logger_exclude: bool = false
var all_loggers = []

const ID = "com.rosepen.console"


func _ready() -> void:
	Debug.logs_changed.connect(_update_logs)
	_update_logs()
	if !CommandBar.command_exists(ID + "/Clear Console"):
		CommandBar.add_command(
			"Clear Console", ID, Icons.get_icon_path("Terminal"), _on_clear_pressed, [], ["console"]
		)
	if !CommandBar.command_exists(ID + "/Toggle Logs"):
		CommandBar.add_command(
			"Toggle Logs",
			ID,
			Icons.get_icon_path("Terminal"),
			_on_toggle_logs_pressed,
			[],
			["console"]
		)
	if !CommandBar.command_exists(ID + "/Toggle Warns"):
		CommandBar.add_command(
			"Toggle Warns",
			ID,
			Icons.get_icon_path("Terminal"),
			_on_toggle_warns_pressed,
			[],
			["console"]
		)
	if !CommandBar.command_exists(ID + "/Toggle Errors"):
		CommandBar.add_command(
			"Toggle Errors",
			ID,
			Icons.get_icon_path("Terminal"),
			_on_toggle_errors_pressed,
			[],
			["console"]
		)

	if !CommandBar.command_has_action(ID + "/Clear Console"):
		CommandBar.link_action(_on_clear_pressed, ID + "/Clear Console")
	if !CommandBar.command_has_action(ID + "/Toggle Logs"):
		CommandBar.link_action(_on_toggle_logs_pressed, ID + "/Toggle Logs")
	if !CommandBar.command_has_action(ID + "/Toggle Warns"):
		CommandBar.link_action(_on_toggle_warns_pressed, ID + "/Toggle Warns")
		CommandBar.link_action(_on_toggle_errors_pressed, ID + "/Toggle Errors")


func _update_logs():
	text.clear()
	for i in Debug.get_logs().size():
		if logger_exclude:
			if logger_filter != [] and logger_filter.has(Debug.logger_ids[i]):
				continue
		else:
			if logger_filter != [] and !logger_filter.has(Debug.logger_ids[i]):
				continue
		var log_string: String
		if Settings.get_option_value("com.rosepen.console/show_timestamps"):
			log_string = (
				"[" + Debug.get_formated_time(Debug.log_seconds[i]) + "] " + Debug.get_logs()[i]
			)
		else:
			log_string = Debug.get_logs()[i]
		var log_num = str(i)
		for e in range(str(Debug.get_logs().size()).split("").size() - str(i).split("").size()):
			log_num = "0" + log_num
		match Debug.log_type[i]:
			"Info":
				if show_logs:
					text.append_text("[color=ACACAC]" + log_num + "[/color] " + log_string)
					text.newline()
			"Warn":
				if show_warns:
					text.append_text(
						(
							"[color=ACACAC]"
							+ log_num
							+ "[/color] [color=FBC600]"
							+ log_string
							+ " [/color]"
						)
					)
					text.newline()
			"Error":
				if show_errors:
					text.append_text(
						(
							"[color=ACACAC]"
							+ log_num
							+ "[/color] [color=D72D2C]"
							+ log_string
							+ " [/color]"
						)
					)
					text.newline()

	log_count.set_text(str(Debug.log_count))
	warn_count.set_text(str(Debug.warn_count))
	error_count.set_text(str(Debug.error_count))

	if (
		Settings.get_option_value(ID + "/notify_errors")
		and Debug.log_type[Debug.get_logs().size() - 1] == "Error"
	):
		NotificationManager.queue_notification(
			"New Error In Console",
			Debug.get_logs()[Debug.get_logs().size() - 1],
			false,
			Sidebar.select_tab,
			[ID],
			4
		)
	if (
		Settings.get_option_value(ID + "/notify_warns")
		and Debug.log_type[Debug.get_logs().size() - 1] == "Warn"
	):
		NotificationManager.queue_notification(
			"New Warning In Console",
			Debug.get_logs()[Debug.get_logs().size() - 1],
			false,
			Sidebar.select_tab,
			[ID],
			4
		)

	all_loggers = []
	var temp_array := []
	for logger in Debug.logger_ids:
		if temp_array.has(logger):
			continue
		temp_array.append(logger)
	all_loggers = temp_array


func _on_toggle_logs_pressed() -> void:
	if show_logs:
		show_logs = false
		log_toggle.set_color("Gray")
		log_toggle.tooltip_display_text = "Show logs"
	else:
		show_logs = true
		log_toggle.set_color("Yellow")
		log_toggle.tooltip_display_text = "Hide logs"
	_update_logs()


func _on_toggle_warns_pressed() -> void:
	if show_warns:
		show_warns = false
		warn_toggle.set_color("Gray")
		warn_toggle.tooltip_display_text = "Show warnings"
	else:
		show_warns = true
		warn_toggle.set_color("Orange")
		warn_toggle.tooltip_display_text = "Hide warnings"
	_update_logs()


func _on_toggle_errors_pressed() -> void:
	if show_errors:
		show_errors = false
		error_toggle.set_color("Gray")
		error_toggle.tooltip_display_text = "Show errors"
	else:
		show_errors = true
		error_toggle.set_color("Red")
		error_toggle.tooltip_display_text = "Hide errors"
	_update_logs()


func _on_clear_pressed() -> void:
	Debug.clear_logs()
	_update_logs()


func get_value():
	pass


func set_value():
	pass


func _on_filters_pressed() -> void:
	Popups.create_popup(preload("res://DeveloperPlugins/Console/ConsoleFilterPopup.tscn"))
	await Popups.popup_created
	var popup = Popups.get_popup()
	if all_loggers == []:
		for logger in Debug.logger_ids:
			if all_loggers.has(logger):
				continue
			all_loggers.append(logger)
	var selected
	if logger_filter == []:
		selected = "No Filter"
	else:
		selected = logger_filter[0]
	popup.console = self
	popup.setup(all_loggers, selected)
