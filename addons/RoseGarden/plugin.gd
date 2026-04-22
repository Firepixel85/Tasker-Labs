@tool
extends EditorPlugin

const AUTOLOADS = {
	"RoseGarden": "res://addons/RoseGarden/globals/RoseGarden.gd",
}

const DialogScene = preload("res://addons/RoseGarden/editor/RGcomponent_dialogue.tscn")
const ACTION_NAME = "rose_garden_create_component"
var _toolbar_button: Button
var _dialog: Window
const SettingsScene = preload("res://addons/RoseGarden/editor/RGsettings_panel.tscn")
var _settings_panel: PanelContainer

func _enter_tree() -> void:
	for name in AUTOLOADS:
		add_autoload_singleton(name, AUTOLOADS[name])

	_dialog = DialogScene.instantiate()

	# Attach to the editor's base control so it renders over the viewport
	EditorInterface.get_base_control().add_child(_dialog)
	_dialog.component_selected.connect(_on_component_selected)

	_toolbar_button = Button.new()
	_toolbar_button.name = "AddRoseGardenComponent"
	_toolbar_button.text = ""
	_toolbar_button.icon = load("res://addons/RoseGarden/IconColors/Icon"+str(randi_range(1,3))+".svg")
	_toolbar_button.tooltip_text = "Add Rose Garden Component"
	_dialog.hide()

	var shortcut := Shortcut.new()
	var default_key := InputEventKey.new()
	default_key.keycode = KEY_G
	default_key.command_or_control_autoremap = true
	default_key.shift_pressed = true
	shortcut.events = [default_key]
	_settings_panel = SettingsScene.instantiate()
	_on_shortcut_changed(_settings_panel.get_current_shortcut())
	add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_BL, _settings_panel)

	# Load saved shortcut instead of hardcoding
	_toolbar_button.shortcut = _settings_panel.get_current_shortcut()
	_toolbar_button.shortcut_in_tooltip = true

	_toolbar_button.shortcut = shortcut
	_toolbar_button.shortcut_in_tooltip = true
	_toolbar_button.pressed.connect(_on_toolbar_button_pressed)
	add_control_to_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _toolbar_button)
	var editor_settings := EditorInterface.get_editor_settings()

	if not editor_settings.has_setting("addons/rose_garden/open_dialog_shortcut"):
		editor_settings.set_setting("addons/rose_garden/open_dialog_shortcut", "Ctrl+Shift+G")
		editor_settings.set_initial_value("addons/rose_garden/open_dialog_shortcut", "Ctrl+Shift+G", false)


func _exit_tree() -> void:
	for name in AUTOLOADS:
		remove_autoload_singleton(name)

	if _toolbar_button:
		remove_control_from_container(EditorPlugin.CONTAINER_CANVAS_EDITOR_MENU, _toolbar_button)
		_toolbar_button.queue_free()

	if _dialog:
		_dialog.queue_free()
	if _settings_panel:
		remove_control_from_docks(_settings_panel)
		_settings_panel.queue_free()



func _on_toolbar_button_pressed() -> void:
	_toolbar_button.icon = load("res://addons/RoseGarden/IconColors/Icon"+str(randi_range(1,3))+".svg")
	_dialog.popup_centered()
	_dialog.search.select_all()
	_dialog.list.select(0)
	_dialog.search.edit()


func _on_component_selected(scene_path: String) -> void:
	var edited_root := EditorInterface.get_edited_scene_root()
	if not edited_root:
		push_warning("RoseGarden: No scene is currently open.")
		return
	var selection := EditorInterface.get_selection().get_selected_nodes()
	var parent: Node = selection[0] if not selection.is_empty() else edited_root
	var instance := (load(scene_path) as PackedScene).instantiate()

	# If the parent already has a child with this name, append an incrementing number
	var base_name := instance.name
	var candidate := base_name
	var counter := 2
	while parent.has_node(NodePath(candidate)):
		candidate = base_name + str(counter)
		counter += 1
		instance.name = candidate

	var undo := get_undo_redo()
	undo.create_action("Add RG Component")
	undo.add_do_method(parent, "add_child", instance)
	undo.add_do_method(instance, "set_owner", edited_root)
	undo.add_undo_method(parent, "remove_child", instance)
	undo.commit_action()

	EditorInterface.get_selection().clear()
	EditorInterface.get_selection().add_node(instance)

func _on_shortcut_changed(new_shortcut: Shortcut) -> void:
	_toolbar_button.shortcut = new_shortcut
	await get_tree().create_timer(2).timeout
	_on_shortcut_changed(_settings_panel.get_current_shortcut())
