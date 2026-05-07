extends Control
class_name PluginInstalled

@onready var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var display_name: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Name
@onready var version: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Version
@onready var developer_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/DeveloperTag
@onready var trusted_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TrustedTag
@onready var version_controlled_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionControlledTag
@onready var toggle: RGToggle = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Toggle
@onready var uninstall: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Uninstall
@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description

var plugin_id:String = ""
signal state_changed

func update():
	display_name.set_text(PluginManager.get_plugin_name(plugin_id))
	version.set_text("v"+PluginManager.get_plugin_version(plugin_id))
	description.text = PluginManager.get_plugin_description(plugin_id)
	if PluginManager.is_developer_plugin(plugin_id):
		uninstall.set_disabled(true)
		developer_tag.visible = true
	else:		developer_tag.visible = false
	if PluginManager.is_plugin_trusted(plugin_id):
		trusted_tag.visible = true
	else:		trusted_tag.visible = false
	if PluginManager.is_plugin_version_controlled(plugin_id):
		version_controlled_tag.visible = true
	else:		version_controlled_tag.visible = false
	toggle.set_state(PluginManager.is_plugin_loaded(plugin_id),true)
	toggle.set_color(Settings.get_option_value("core.appearance/accent_color"))
	Settings.setting_changed.connect(_on_setting_changed)
	return OK

func _on_uninstall_de_hovered() -> void:
	if !PluginManager.is_developer_plugin(plugin_id):
		uninstall.set_color("Gray")

func _on_uninstall_hovered() -> void:
	if !PluginManager.is_developer_plugin(plugin_id):
		uninstall.set_color("Red")


func _on_toggle_toggled(toggled_on: bool) -> void:
	if toggled_on:
		PluginManager.load_plugin(plugin_id)
	else:
		PluginManager.unload_plugin(plugin_id)
	state_changed.emit()

func _on_setting_changed(option_path:String,new_value) -> void:
	if option_path == "core.appearance/accent_color":
		toggle.set_color(new_value)
