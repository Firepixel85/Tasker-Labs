extends Control

@onready
var title: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Title
@onready
var author: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Author
@onready
var version_diff: RGText = $"RGContainer/MarginContainer/VBoxContainer/HBoxContainer/RGContainer/CenterContainer/MarginContainer/Version Diff"
@onready
var version_diff_container: Control = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/RGContainer
@onready
var update_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Update

@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var container: Control = $RGContainer
@onready var trusted: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Trusted

var id: String
var trusted_hovered: bool = false
var url

signal updated


func setup():
	title.text = PluginManager.get_plugin_name(id)
	author.text = PluginManager.get_plugin_author(id)
	version_diff.text = (PluginManager.get_plugin_version(id) + " → " + PluginManager.get_plugin_latest_version(id))
	await get_tree().process_frame
	version_diff_container.custom_minimum_size.x = version_diff.get_parent().get_minimum_size().x
	version_diff_container._update()
	if PluginManager.plugin_has_description(id):
		description.text = PluginManager.get_plugin_description(id)
	else:
		description.text = ""
	if PluginManager.is_plugin_trusted(id):
		trusted.show()
	container._update()
	url = await PluginManager.get_plugin_repo_site(id)


func _on_trusted_mouse_entered() -> void:
	trusted_hovered = true
	await get_tree().create_timer(1).timeout
	if !trusted_hovered:
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text("Trusted plugin")
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _on_trusted_mouse_exited() -> void:
	trusted_hovered = false
	RoseGarden.clear_tooltips()


func _on_more_pressed() -> void:
	var menu = RGmenu.new()
	menu.add_action(
		"View changelog",
		Icons.FILETEXT,
		OS.shell_open,
		[url + "/releases/tag/" + PluginManager.get_plugin_latest_tag(id)]
	)
	menu.add_action("View source", Icons.CODE, OS.shell_open, [url])
	RoseGarden.create_rc_menu(menu, get_global_mouse_position())


func _on_update_pressed() -> void:
	update_button.disabled = true
	update_button.text = "Updating..."
	await PluginManager.update_plugin(id)
	update_button.disabled = false
	update_button.text = "Update"
	RoseGarden.create_toast("Plugin updated!", "Green")
	updated.emit()
