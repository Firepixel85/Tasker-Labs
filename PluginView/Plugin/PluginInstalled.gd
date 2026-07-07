extends Control
class_name PluginInstalled

@onready
var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/Icon
@onready
var display_name: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Name
@onready
var version: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/Version
@onready
var toggle: RGToggle = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Toggle
@onready
var uninstall: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Uninstall
@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready
var author: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/Author

#Tags
@onready
var developer_tag: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/DeveloperTag
var developer_tag_hovered: bool = false
@onready
var trusted_tag: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TrustedTag
var trusted_tag_hovered: bool = false
@onready
var version_controlled_tag: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionControlledTag
var version_controlled_tag_hovered: bool = false

var plugin_id: String = ""
var keybind_number: int  ##The number associated with the shown keybind to toggle this plugin
signal state_changed(plugin_id: String)


func setup():
	display_name.set_text(PluginManager.get_plugin_name(plugin_id))
	version.set_text("v" + PluginManager.get_plugin_version(plugin_id))
	description.text = PluginManager.get_plugin_description(plugin_id)
	author.set_text(PluginManager.get_plugin_author(plugin_id))
	if PluginManager.is_developer_plugin(plugin_id):
		uninstall.set_disabled(true)
		developer_tag.visible = true
	else:
		developer_tag.visible = false
	if PluginManager.is_plugin_trusted(plugin_id):
		trusted_tag.visible = true
	else:
		trusted_tag.visible = false
	if PluginManager.is_plugin_version_controlled(plugin_id):
		version_controlled_tag.visible = true
	else:
		version_controlled_tag.visible = false
	if PluginManager.plugin_has_icon(plugin_id):
		icon.texture = PluginManager.get_plugin_icon(plugin_id)
	else:
		icon.hide()
	toggle.set_state(PluginManager.is_plugin_loaded(plugin_id), true)
	toggle.set_color(Settings.get_option_value("core.appearance/accent_color"))
	toggle.set_accessible(Settings.get_option_value("core.accessibility/symbol_indicators"))
	Settings.setting_changed.connect(_on_setting_changed)
	return OK


func _on_uninstall_de_hovered() -> void:
	if !PluginManager.is_developer_plugin(plugin_id):
		uninstall.set_color("Gray")
	RoseGarden.clear_tooltips()


func _on_uninstall_hovered() -> void:
	if !PluginManager.is_developer_plugin(plugin_id):
		uninstall.set_color("Red")
	await get_tree().create_timer(1).timeout
	if !uninstall.is_hovered():
		return
	var tooltip = RGTooltip.new()
	if PluginManager.is_developer_plugin(plugin_id):
		tooltip.set_text("Developer plugins can't be uninstalled")
	else:
		tooltip.set_text("Uninstall " + PluginManager.get_plugin_name(plugin_id) + " plugin")
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _on_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PluginManager.load_plugin(plugin_id)
	else:
		PluginManager.unload_plugin(plugin_id)
	state_changed.emit(plugin_id)


func _on_setting_changed(option_path: String, new_value) -> void:
	if option_path == "core.appearance/accent_color":
		toggle.set_color(new_value)
	if option_path == "core.accessibility/symbol_indicators":
		toggle.set_accessible(new_value)


func _on_developer_tag_mouse_entered() -> void:
	developer_tag_hovered = true
	await get_tree().create_timer(1).timeout
	if !developer_tag_hovered:
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Developer plugin")
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _on_developer_tag_mouse_exited() -> void:
	developer_tag_hovered = false
	RoseGarden.clear_tooltips()


func _on_trusted_tag_mouse_entered() -> void:
	trusted_tag_hovered = true
	await get_tree().create_timer(1).timeout
	if !trusted_tag_hovered:
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Trusted plugin developer")
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _on_trusted_tag_mouse_exited() -> void:
	trusted_tag_hovered = false
	RoseGarden.clear_tooltips()


func _on_version_controlled_tag_mouse_entered() -> void:
	version_controlled_tag_hovered = true
	await get_tree().create_timer(1).timeout
	if !version_controlled_tag_hovered:
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Version controlled plugin")
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _on_version_controlled_tag_mouse_exited() -> void:
	version_controlled_tag_hovered = false
	RoseGarden.clear_tooltips()


func _on_developer_tag_pressed() -> void:
	Popups.create_popup(preload("res://PluginView/Plugin/Popups/Developer.tscn"))


func _on_trusted_tag_pressed() -> void:
	Popups.create_popup(preload("res://PluginView/Plugin/Popups/Trusted.tscn"))


func _on_version_controlled_tag_pressed() -> void:
	Popups.create_popup(preload("res://PluginView/Plugin/Popups/VersionControlled.tscn"))


func _on_toggle_hovered() -> void:
	await get_tree().create_timer(1).timeout
	if !toggle.is_hovered():
		return
	var tooltip = RGTooltip.new()
	if PluginManager.is_plugin_loaded(plugin_id):
		tooltip.set_text("Disable " + PluginManager.get_plugin_name(plugin_id) + " plugin")
		tooltip.set_show_keybind(true)
		tooltip.set_keybind("⇧" + str(keybind_number))
	else:
		tooltip.set_text("Enable " + PluginManager.get_plugin_name(plugin_id) + " plugin")
		tooltip.set_show_keybind(true)
		tooltip.set_keybind("⌥" + str(keybind_number))
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _on_toggle_dehovered() -> void:
	RoseGarden.clear_tooltips()


func _on_uninstall_pressed() -> void:
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.DOUBLE_ACTION)
	popup.set_title("Are you sure?")
	(popup . set_description( "This is a permenant action that will immediately delete all files asscoiated with this plugin. Are you sure?" ))
	popup.add_action(empty, "Cancel", [], "Gray")
	popup.add_action(empty, "Uninstall", [], "Red")
	Popups.create_prefab_popup(popup)


func copy_id():
	DisplayServer.clipboard_set(plugin_id)


func _on_rg_container_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_RIGHT and event.pressed):
		var menu = RGmenu.new()
		menu.add_action("Toggle plugin", Icons.TOGGLE, toggle.toggle)
		menu.add_action("Copy plugin ID", Icons.CODE, copy_id)
		if !PluginManager.is_developer_plugin(plugin_id):
			menu.add_seperator()
			menu.add_action("Delete plugin", Icons.TRASH, _on_uninstall_pressed, [], true)
		RoseGarden.create_rc_menu(menu, get_global_mouse_position())


func show_keybind(keybind_num: String):
	icon.texture = load("res://PluginView/Plugin/Keybinds/Keybind" + keybind_num + ".svg")
	icon.show()


func hide_keybind():
	if PluginManager.plugin_has_icon(plugin_id):
		icon.texture = PluginManager.get_plugin_icon(plugin_id)
	else:
		icon.hide()


func empty():  #Like my brain
	pass
