extends Control
class_name PluginInstalled

@onready var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var display_name: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Name
@onready var version: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Version
@onready var toggle: RGToggle = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Toggle
@onready var uninstall: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Uninstall
@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description

#Tags
@onready var developer_tag: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/DeveloperTag
var developer_tag_hovered:bool = false
@onready var trusted_tag: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TrustedTag
var trusted_tag_hovered:bool = false
@onready var version_controlled_tag: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionControlledTag
var version_controlled_tag_hovered:bool = false

var plugin_id:String = ""
signal state_changed(plugin_id:String)

func setup():
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
	state_changed.emit(plugin_id)

func _on_setting_changed(option_path:String,new_value) -> void:
	if option_path == "core.appearance/accent_color":
		toggle.set_color(new_value)


func _on_developer_tag_mouse_entered() -> void:
	developer_tag_hovered = true
	await get_tree().create_timer(1).timeout
	if !developer_tag_hovered:
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Developer plugin")
	RoseGarden.create_tooltip(tooltip,get_global_mouse_position())

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
	RoseGarden.create_tooltip(tooltip,get_global_mouse_position())

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
	RoseGarden.create_tooltip(tooltip,get_global_mouse_position())


func _on_version_controlled_tag_mouse_exited() -> void:
	version_controlled_tag_hovered = false
	RoseGarden.clear_tooltips()


func _on_developer_tag_pressed() -> void:
	print("test")
	Popups.add_popup(preload("res://Plugins/Plugin/Popups/Developer.tscn"))

func _on_trusted_tag_pressed() -> void:
	Popups.add_popup(preload("res://Plugins/Plugin/Popups/Trusted.tscn"))

func _on_version_controlled_tag_pressed() -> void:
	Popups.add_popup(preload("res://Plugins/Plugin/Popups/VersionControlled.tscn"))
