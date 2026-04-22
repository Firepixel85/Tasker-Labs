@tool
extends PanelContainer

signal shortcut_changed(shortcut: Shortcut)

const SETTINGS_KEY = "addons/rose_garden/open_dialog_shortcut"

@onready var shortcut_button: Button = $VBoxContainer/HBoxContainer/Button

var _listening := false
var _current_shortcut: Shortcut

func _ready() -> void:
	_load_shortcut()
	shortcut_button.pressed.connect(_on_shortcut_button_pressed)
	shortcut_button.focus_exited.connect(_stop_listening)

func _load_shortcut() -> void:
	var editor_settings := EditorInterface.get_editor_settings()
	if not editor_settings.has_setting(SETTINGS_KEY):
		#Write the default if it doesn't exist yet
		var default_key := InputEventKey.new()
		default_key.keycode = KEY_G
		default_key.command_or_control_autoremap = true
		default_key.shift_pressed = true
		_current_shortcut = Shortcut.new()
		_current_shortcut.events = [default_key]
		_save_shortcut(_current_shortcut)
	else:
		_current_shortcut = editor_settings.get_setting(SETTINGS_KEY) as Shortcut

	_update_button_label()

func _on_shortcut_button_pressed() -> void:
	_listening = true
	shortcut_button.text = "Press a key combination..."
	shortcut_button.grab_focus()

func _input(event: InputEvent) -> void:
	if not _listening:
		return
	if not (event is InputEventKey) or not event.pressed:
		return
	# Ignore bare modifier presses — wait for an actual key
	if event.keycode in [KEY_CTRL, KEY_SHIFT, KEY_ALT, KEY_META]:
		return

	get_viewport().set_input_as_handled()
	_listening = false

	var new_shortcut := Shortcut.new()
	var new_event := InputEventKey.new()
	new_event.keycode = event.keycode
	new_event.command_or_control_autoremap = event.ctrl_pressed or event.meta_pressed
	new_event.shift_pressed = event.shift_pressed
	new_event.alt_pressed = event.alt_pressed
	new_shortcut.events = [new_event]

	_current_shortcut = new_shortcut
	_save_shortcut(new_shortcut)
	_update_button_label()
	shortcut_changed.emit(new_shortcut)

func _stop_listening() -> void:
	if _listening:
		_listening = false
		_update_button_label()

func _save_shortcut(shortcut: Shortcut) -> void:
	EditorInterface.get_editor_settings().set_setting(SETTINGS_KEY, shortcut)

func _update_button_label() -> void:
	if _current_shortcut and not _current_shortcut.events.is_empty():
		shortcut_button.text = _current_shortcut.events[0].as_text()
	else:
		shortcut_button.text = "None"

func get_current_shortcut() -> Shortcut:
	return _current_shortcut
