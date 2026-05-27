extends Control
@onready var enabled_container: HBoxContainer = $VBoxContainer/ScrollContainer/HBoxContainer
@onready var disabled_container: HBoxContainer = $VBoxContainer/ScrollContainer2/HBoxContainer
@onready var disabled_text: RGText = $VBoxContainer/Disabled
@onready var enabled_text: RGText = $VBoxContainer/Enabled
@onready var animation_layer: CanvasLayer = $CanvasLayer

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
		else:
			disabled_container.add_child(plugin_view)
			plugin_view = disabled_container.get_child(disabled_container.get_child_count()-1)
		plugin_view.plugin_id = plugin_id
		plugin_view.setup()
		plugin_view.state_changed.connect(move_plugin)
		plugin_view.scale = Vector2(1,1)

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

func move_plugin(plugin_id:String):
	for child in enabled_container.get_children():
		child.queue_free()
	for child in disabled_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	enabled_container.get_parent().visible = true
	enabled_text.visible = true
	disabled_container.get_parent().visible = true
	disabled_text.visible = true
	var plugin_enabled:PluginInstalled
	var plugin_disabled:PluginInstalled
	for plugin in PluginManager.get_all_plugins():
		if PluginManager.is_developer_plugin(plugin_id) and !Settings.get_option_value("core.developer/dev_tools"):
			return

		if plugin == plugin_id:
			enabled_container.add_child(preload("res://Plugins/Plugin/PluginInstalled.tscn").instantiate())
			plugin_enabled = enabled_container.get_child(enabled_container.get_child_count()-1)
			plugin_enabled.plugin_id = plugin_id
			plugin_enabled.setup()
			plugin_enabled.modulate = Color(0,1,0,0)
			disabled_container.add_child(preload("res://Plugins/Plugin/PluginInstalled.tscn").instantiate())
			plugin_disabled = disabled_container.get_child(disabled_container.get_child_count()-1)
			plugin_disabled.plugin_id = plugin_id
			plugin_disabled.setup()
			plugin_disabled.modulate = Color(1,0,0,0)
		else:
			var plugin_view:PluginInstalled = preload("res://Plugins/Plugin/PluginInstalled.tscn").instantiate()
			if PluginManager.is_plugin_loaded(plugin):
				enabled_container.add_child(plugin_view)
				plugin_view = enabled_container.get_child(enabled_container.get_child_count()-1)
			else:
				disabled_container.add_child(plugin_view)
				plugin_view = disabled_container.get_child(disabled_container.get_child_count()-1)
			plugin_view.plugin_id = plugin
			plugin_view.setup()
			plugin_view.state_changed.connect(move_plugin)


	await get_tree().process_frame
	var init_pos = Vector2()
	var final_pos = Vector2()
	if PluginManager.is_plugin_loaded(plugin_id):
		init_pos = plugin_disabled.get_global_transform().origin
		final_pos = plugin_enabled.get_global_transform().origin
	else:
		init_pos = plugin_enabled.get_global_transform().origin
		final_pos = plugin_disabled.get_global_transform().origin
	var anim_plugin = preload("res://Plugins/Plugin/PluginInstalled.tscn").instantiate()
	animation_layer.add_child(anim_plugin)
	anim_plugin = animation_layer.get_child(animation_layer.get_child_count()-1)
	anim_plugin.plugin_id = plugin_id
	await anim_plugin.setup()
	anim_plugin.position = init_pos
	var tween = create_tween()
	tween.tween_property(anim_plugin,"position",final_pos,0.3*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	if PluginManager.is_plugin_loaded(plugin_id):
		plugin_enabled.custom_minimum_size = Vector2(0,256)
		tween.parallel().tween_property(plugin_enabled,"custom_minimum_size",Vector2(512,256),0.3*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(plugin_disabled,"custom_minimum_size",Vector2(0,256),0.3*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	else:
		plugin_disabled.custom_minimum_size = Vector2(0,256)
		tween.parallel().tween_property(plugin_disabled,"custom_minimum_size",Vector2(512,256),0.3*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.parallel().tween_property(plugin_enabled,"custom_minimum_size",Vector2(0,256),0.3*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	animation_layer.remove_child(anim_plugin)
	if PluginManager.is_plugin_loaded(plugin_id):
		plugin_disabled.queue_free()
		plugin_enabled.modulate = Color(1,1,1,1)
		plugin_enabled.state_changed.connect(move_plugin)
	else:
		plugin_enabled.queue_free()
		plugin_disabled.modulate = Color(1,1,1,1)
		plugin_disabled.state_changed.connect(move_plugin)
