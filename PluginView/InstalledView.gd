extends Control
@onready
var enabled_container: GridContainer = $HBoxContainer/VBoxContainer/ScrollContainer/GridContainer
@onready
var disabled_container: GridContainer = $HBoxContainer/VBoxContainer2/ScrollContainer2/GridContainer
@onready var disabled_text: RGText = $HBoxContainer/VBoxContainer2/RGText
@onready var enabled_text: RGText = $HBoxContainer/VBoxContainer/RGText
@onready var animation_layer: CanvasLayer = $CanvasLayer
@onready var action_container: Control = $ActionContainer

#Actions
@onready var updates_button: RGButton = $ActionContainer/MarginContainer/HBoxContainer/Updates
@onready var folder_button: RGButton = $ActionContainer/MarginContainer/HBoxContainer/Folder
@onready var refresh_button: RGButton = $ActionContainer/MarginContainer/HBoxContainer/Refresh

var _checked_shift_key_held: bool = false
var _checked_option_key_held: bool = false
var shift_keybinds_shown: bool = false
var option_keybinds_shown: bool = false


func display_plugins():
	for child in enabled_container.get_children():
		child.queue_free()
	for child in disabled_container.get_children():
		child.queue_free()
	await get_tree().process_frame

	for plugin_id in PluginManager.get_all_plugins():
		if (PluginManager.is_developer_plugin(plugin_id) and !Settings.get_option_value("core.developer/dev_tools")):
			return

		var plugin_view: PluginInstalled = (preload("res://PluginView/Plugin/PluginInstalled.tscn").instantiate())
		if PluginManager.is_plugin_loaded(plugin_id):
			enabled_container.add_child(plugin_view)
			plugin_view = enabled_container.get_child(enabled_container.get_child_count() - 1)
		else:
			disabled_container.add_child(plugin_view)
			plugin_view = disabled_container.get_child(disabled_container.get_child_count() - 1)
		plugin_view.plugin_id = plugin_id
		plugin_view.setup()
		plugin_view.state_changed.connect(move_plugin)
		plugin_view.scale = Vector2(1, 1)

	for i in enabled_container.get_children().size():
		if i > 9:
			break
		var new_i
		if i == 9:
			new_i = 0
		else:
			new_i = i + 1
		enabled_container.get_child(i).keybind_number = new_i
	for i in disabled_container.get_children().size():
		if i > 9:
			break
		var new_i
		if i == 9:
			new_i = 0
		else:
			new_i = i + 1
		disabled_container.get_child(i).keybind_number = new_i

	action_container.custom_minimum_size.x = action_container.get_child(1).get_minimum_size().x
	action_container._update()


func move_plugin(plugin_id: String):
	for child in enabled_container.get_children():
		child.queue_free()
	for child in disabled_container.get_children():
		child.queue_free()
	await get_tree().process_frame
	enabled_container.get_parent().visible = true
	enabled_text.visible = true
	disabled_container.get_parent().visible = true
	disabled_text.visible = true
	var plugin_enabled: PluginInstalled
	var plugin_disabled: PluginInstalled
	for plugin in PluginManager.get_all_plugins():
		if (PluginManager.is_developer_plugin(plugin_id) and !Settings.get_option_value("core.developer/dev_tools")):
			return

		if plugin == plugin_id:
			enabled_container.add_child(preload("res://PluginView/Plugin/PluginInstalled.tscn").instantiate())
			plugin_enabled = enabled_container.get_child(enabled_container.get_child_count() - 1)
			plugin_enabled.plugin_id = plugin_id
			plugin_enabled.setup()
			plugin_enabled.modulate = Color(0, 1, 0, 0)
			disabled_container.add_child(preload("res://PluginView/Plugin/PluginInstalled.tscn").instantiate())
			plugin_disabled = disabled_container.get_child(disabled_container.get_child_count() - 1)
			plugin_disabled.plugin_id = plugin_id
			plugin_disabled.setup()
			plugin_disabled.modulate = Color(1, 0, 0, 0)
		else:
			var plugin_view: PluginInstalled = (preload("res://PluginView/Plugin/PluginInstalled.tscn").instantiate())
			if PluginManager.is_plugin_loaded(plugin):
				enabled_container.add_child(plugin_view)
				plugin_view = enabled_container.get_child(enabled_container.get_child_count() - 1)
			else:
				disabled_container.add_child(plugin_view)
				plugin_view = disabled_container.get_child(disabled_container.get_child_count() - 1)
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
	var anim_plugin = preload("res://PluginView/Plugin/PluginInstalled.tscn").instantiate()
	animation_layer.add_child(anim_plugin)
	anim_plugin = animation_layer.get_child(animation_layer.get_child_count() - 1)
	anim_plugin.plugin_id = plugin_id
	await anim_plugin.setup()
	anim_plugin.position = init_pos
	var tween = create_tween()
	(tween . tween_property( anim_plugin, "position", final_pos, 0.3 * int(!RoseGarden.Accessibility.disableAnimations) ) . set_ease(Tween.EASE_OUT) . set_trans(Tween.TRANS_CUBIC))
	if PluginManager.is_plugin_loaded(plugin_id):
		plugin_enabled.custom_minimum_size = Vector2(0, 256)
		(tween . parallel() . tween_property( plugin_enabled, "custom_minimum_size", Vector2(512, 256), 0.3 * int(!RoseGarden.Accessibility.disableAnimations) ) . set_ease(Tween.EASE_OUT) . set_trans(Tween.TRANS_CUBIC))
		(tween . parallel() . tween_property( plugin_disabled, "custom_minimum_size", Vector2(0, 256), 0.3 * int(!RoseGarden.Accessibility.disableAnimations) ) . set_ease(Tween.EASE_OUT) . set_trans(Tween.TRANS_CUBIC))
	else:
		plugin_disabled.custom_minimum_size = Vector2(0, 256)
		(tween . parallel() . tween_property( plugin_disabled, "custom_minimum_size", Vector2(512, 256), 0.3 * int(!RoseGarden.Accessibility.disableAnimations) ) . set_ease(Tween.EASE_OUT) . set_trans(Tween.TRANS_CUBIC))
		(tween . parallel() . tween_property( plugin_enabled, "custom_minimum_size", Vector2(0, 256), 0.3 * int(!RoseGarden.Accessibility.disableAnimations) ) . set_ease(Tween.EASE_OUT) . set_trans(Tween.TRANS_CUBIC))
	await tween.finished
	animation_layer.remove_child(anim_plugin)
	if PluginManager.is_plugin_loaded(plugin_id):
		plugin_disabled.queue_free()
		plugin_enabled.modulate = Color(1, 1, 1, 1)
		plugin_enabled.state_changed.connect(move_plugin)
	else:
		plugin_enabled.queue_free()
		plugin_disabled.modulate = Color(1, 1, 1, 1)
		plugin_disabled.state_changed.connect(move_plugin)

	for i in enabled_container.get_children().size():
		if i > 9:
			break
		var new_i
		if i == 9:
			new_i = 0
		else:
			new_i = i + 1
		enabled_container.get_child(i).keybind_number = new_i
	for i in disabled_container.get_children().size():
		if i > 9:
			break
		var new_i
		if i == 9:
			new_i = 0
		else:
			new_i = i + 1
		disabled_container.get_child(i).keybind_number = new_i


func _process(_delta: float) -> void:
	if Main.get_current_view() != "plugins":
		return
	if !Input.is_key_pressed(KEY_SHIFT) and shift_keybinds_shown:
		_close_keybinds(true)
	elif !_checked_shift_key_held:
		_checked_shift_key_held = true
		_check_shift_held()

	if !Input.is_key_pressed(KEY_ALT) and option_keybinds_shown:
		_close_keybinds(false)
	elif !_checked_option_key_held:
		_checked_option_key_held = true
		_check_option_held()

	if Input.is_action_just_pressed("plugins_folder"):
		folder_button.press()
	if Input.is_action_just_pressed("plugins_refresh"):
		refresh_button.press()
	if Input.is_action_just_pressed("plugins_updates"):
		updates_button.press()

	for i in range(9):
		if (Input.is_action_just_pressed(str(i + 1)) and Input.is_key_pressed(KEY_SHIFT) and enabled_container.get_child_count() > i):
			PluginManager.unload_plugin(enabled_container.get_child(i).plugin_id)
			move_plugin(enabled_container.get_child(i).plugin_id)
		elif (Input.is_action_just_pressed(str(i + 1)) and Input.is_key_pressed(KEY_ALT) and disabled_container.get_child_count() > i):
			PluginManager.load_plugin(disabled_container.get_child(i).plugin_id)
			move_plugin(disabled_container.get_child(i).plugin_id)


func _check_shift_held():
	await get_tree().create_timer(0.5).timeout
	_checked_shift_key_held = false
	if Input.is_key_pressed(KEY_SHIFT):
		_open_keybinds(true)


func _check_option_held():
	await get_tree().create_timer(0.5).timeout
	_checked_option_key_held = false
	if Input.is_key_pressed(KEY_ALT):
		_open_keybinds(false)


func _open_keybinds(enabled: bool):
	var container
	if enabled:
		shift_keybinds_shown = true
		container = enabled_container
	else:
		option_keybinds_shown = true
		container = disabled_container
	for i in range(container.get_child_count()):
		if i > 9:
			break
		var plugin_view: PluginInstalled = container.get_child(i)
		plugin_view.show_keybind(str(i + 1))


func _close_keybinds(enabled: bool):
	var container
	if enabled:
		shift_keybinds_shown = false
		container = enabled_container
	else:
		option_keybinds_shown = false
		container = disabled_container
	for i in range(container.get_child_count()):
		if i > 9:
			break
		var plugin_view: PluginInstalled = container.get_child(i)
		plugin_view.hide_keybind()


func refresh(toast: bool = true) -> void:
	await PluginManager.scan_available_plugins()
	PluginManager.scan_for_updates()
	display_plugins()
	if toast:
		RoseGarden.create_toast("Plugins Refreshed", "Green", 2.0)


func _on_folder_pressed() -> void:
	OS.shell_show_in_file_manager(OS.get_user_data_dir() + "/plugins")


func _on_updates_pressed() -> void:
	Popups.create_popup(preload("res://PluginView/UpdatesPopup/UpdatesPopup.tscn"))
	await get_tree().process_frame
	await get_tree().process_frame
	Popups.get_popup().updated.connect(refresh)
