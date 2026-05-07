extends Control
@onready var enabled_container: HBoxContainer = $VBoxContainer/ScrollContainer/HBoxContainer
@onready var disabled_container: HBoxContainer = $VBoxContainer/ScrollContainer2/HBoxContainer

func _ready():
	Settings.setting_changed.connect(_on_setting_changed)
func display_plugins():
	for child in enabled_container.get_children():
		child.queue_free()
	for child in disabled_container.get_children():
		child.queue_free()

	for plugin_id in PluginManager.get_all_plugins():
		var plugin_view:PluginInstalled = preload("res://Plugins/Plugin/PluginInstalled.tscn").instantiate()
		if PluginManager.is_plugin_loaded(plugin_id):
			if PluginManager.is_developer_plugin(plugin_id) and !Settings.get_option_value("core.developer/dev_tools"):
				return
			plugin_view.plugin_id = plugin_id
			enabled_container.add_child(plugin_view)
			plugin_view = enabled_container.get_child(enabled_container.get_child_count()-1)
			await plugin_view.update()
			plugin_view.state_changed.connect(display_plugins)
		else:
			if PluginManager.is_developer_plugin(plugin_id) and !Settings.get_option_value("core.developer/dev_tools"):
				return
			plugin_view.plugin_id = plugin_id
			disabled_container.add_child(plugin_view)
			plugin_view = disabled_container.get_child(disabled_container.get_child_count()-1)
			await plugin_view.update()
			plugin_view.state_changed.connect(display_plugins)


func _on_setting_changed(option_path:String,new_value) -> void:
	if option_path == "core.developer/dev_tools":
		display_plugins()
