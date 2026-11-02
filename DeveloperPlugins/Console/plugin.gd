extends Node

const ID = "com.rosepen.console"

func start():
	if !Settings.category_exists(ID):
		Settings.add_category("Console","res://Icons/Terminal.svg",ID)
	else:
		Settings.show_category(ID)
	if !Settings.option_exists(ID+"/show_timestamps"):
		Settings.add_option(ID,"show_timestamps",PluginManager.get_plugin_filepath(ID)+"Settings/ShowTimestamps/ShowTimestamps.tscn",false)
	if !Settings.option_exists(ID+"/notify_warns"):
		Settings.add_option(ID,"notify_warns",PluginManager.get_plugin_filepath(ID)+"Settings/NotifyWarns/NotifyWarns.tscn",false)
	if !Settings.option_exists(ID+"/notify_errors"):
		Settings.add_option(ID,"notify_errors",PluginManager.get_plugin_filepath(ID)+"Settings/NotifyErrors/NotifyErrors.tscn",false)
	Sidebar.add_tab("Console",Icons.TERMINAL,load(PluginManager.get_plugin_filepath(ID)+"Console.tscn"),ID)

	var hotkey_errors:= {}
	var event_of := InputEventKey.new()
	event_of.keycode = KEY_F
	event_of.command_or_control_autoremap = true
	event_of.shift_pressed = true
	hotkey_errors["open_filters"] = HotkeyManager.register_hotkey("Open filters","⌘⇧F",event_of,["console"],ID)

	var event_tl := InputEventKey.new()
	event_tl.keycode = KEY_L
	event_tl.command_or_control_autoremap = true
	event_tl.shift_pressed = true
	hotkey_errors["toggle_logs"] = HotkeyManager.register_hotkey("Toggle logs","⌘⇧L",event_tl,["console"],ID)

	var event_tw := InputEventKey.new()
	event_tw.keycode = KEY_W
	event_tw.command_or_control_autoremap = true
	event_tw.shift_pressed = true
	hotkey_errors["toggle_warns"] = HotkeyManager.register_hotkey("Toggle warns","⌘⇧W",event_tw,["console"],ID)

	var event_te := InputEventKey.new()
	event_te.keycode = KEY_E
	event_te.command_or_control_autoremap = true
	event_te.shift_pressed = true
	hotkey_errors["toggle_errors"] = HotkeyManager.register_hotkey("Toggle errors","⌘⇧E",event_te,["console"],ID)

	var event_c := InputEventKey.new()
	event_c.keycode = KEY_C
	event_c.command_or_control_autoremap = true
	event_c.shift_pressed = true
	hotkey_errors["clear_console"] = HotkeyManager.register_hotkey("Clear console","⌘⇧F",event_c,[],ID)

	for key in hotkey_errors.keys():
		if int(hotkey_errors[key]) == ERR_ALREADY_EXISTS:
			Debug.warn("Failed to register hotkey: "+key,ID)
	Debug.log("Loaded",ID)

func stop():
	HotkeyManager.unregister_hotkey("open_filters")
	HotkeyManager.unregister_hotkey("toggle_logs")
	HotkeyManager.unregister_hotkey("toggle_warns")
	HotkeyManager.unregister_hotkey("toggle_errors")
	HotkeyManager.unregister_hotkey("clear_console")
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)
	Settings.hide_category(ID)

func empty():
	pass
