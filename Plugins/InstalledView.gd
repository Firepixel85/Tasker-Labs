extends Control
@onready var enabled_container: HBoxContainer = $VBoxContainer/ScrollContainer/HBoxContainer
@onready var disabled_container: HBoxContainer = $VBoxContainer/ScrollContainer2/HBoxContainer
@onready var disabled_text: RGText = $VBoxContainer/Disabled
@onready var enabled_text: RGText = $VBoxContainer/Enabled

func _ready():
	Settings.setting_changed.connect(_on_setting_changed)
func display_plugins():
	for child in enabled_container.get_children():
		child.queue_free()
	for child in disabled_container.get_children():
		child.queue_free()
	await get_tree().process_frame

	for plugin_id in PluginManager.get_all_plugins():
		if PluginManager.is_developer_plugin(plugin_id) and !Settings.get_option_value("core.developer/dev_tools"):
			return

		var plugin_view:PluginInstalled = preload("res://Plugins/Plugin/PluginInstalled.tscn").instantiate()
		if PluginManager.is_plugin_loaded(plugin_id):
			enabled_container.add_child(plugin_view)
			plugin_view = enabled_container.get_child(enabled_container.get_child_count()-1)
			plugin_view.plugin_id = plugin_id
			await plugin_view.update()
			plugin_view.state_changed.connect(display_plugins)
		else:
			disabled_container.add_child(plugin_view)
			plugin_view = disabled_container.get_child(disabled_container.get_child_count()-1)
			plugin_view.plugin_id = plugin_id
			await plugin_view.update()
			plugin_view.state_changed.connect(display_plugins)

	await get_tree().process_frame
	enabled_container.get_parent().visible = true
	enabled_text.visible = true
	disabled_container.get_parent().visible = true
	disabled_text.visible = true
	if enabled_container.get_child_count() == 0:
		enabled_container.get_parent().visible = false
		enabled_text.visible = false
	if disabled_container.get_child_count() == 0:
		disabled_container.get_parent().visible = false
		disabled_text.visible = false



func _on_setting_changed(option_path:String,_new_value) -> void:
	if option_path == "core.developer/dev_tools":
		display_plugins()
