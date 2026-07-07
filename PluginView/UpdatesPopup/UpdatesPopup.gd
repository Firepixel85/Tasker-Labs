extends Control
@onready
var view_selector: RGSegmentControl = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/ViewSelector
@onready
var plugin_container: VBoxContainer = $RGContainer/MarginContainer/VBoxContainer/ScrollContainer/PluginContainer
@onready
var scroll_container: ScrollContainer = $RGContainer/MarginContainer/VBoxContainer/ScrollContainer
@onready var fade: TextureRect = $MarginContainer/VBoxContainer/Fade

signal updated(toast: bool)


func _ready() -> void:
	PluginManager.scanned_for_updates.connect(_ready)
	view_selector.add_item("all_updates", "All Updates")
	view_selector.add_item("only_trusted", "Only Trusted")
	for child in plugin_container.get_children():
		child.queue_free()
	if PluginManager.is_rate_limited():
		plugin_container.add_child(
			preload("res://PluginView/UpdatesPopup/RateLimited.tscn").instantiate()
		)
		return
	if PluginManager.get_outdated_plugins() == null:
		plugin_container.add_child(
			preload("res://PluginView/UpdatesPopup/Scanning.tscn").instantiate()
		)
		await PluginManager.scan_for_updates()
		plugin_container.get_child(0).queue_free()
	for plugin in PluginManager.get_outdated_plugins():
		if !PluginManager.is_plugin_trusted(plugin) and view_selector.selected == "only_trusted":
			continue
		plugin_container.add_child(
			preload("res://PluginView/UpdatesPopup/Plugin.tscn").instantiate()
		)
		var target = plugin_container.get_child(plugin_container.get_child_count() - 1)
		target.id = plugin
		target.setup()
		target.updated.connect(_update_complete)
	await get_tree().process_frame
	if plugin_container.get_child_count() == 0:
		plugin_container.add_child(
			preload("res://PluginView/UpdatesPopup/NoResults.tscn").instantiate()
		)


func _on_close_pressed() -> void:
	Popups.clear_popup()


func _on_view_selector_item_selected(_item_name: String) -> void:
	_ready()


func _update_complete() -> void:
	_ready()
	updated.emit(false)
