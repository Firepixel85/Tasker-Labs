extends Node

const ID = "com.rosepen.focus_core"

func start():
	Sidebar.add_tab("FocusCore",Icons.CHECKBOOK,load(PluginManager.get_plugin_filepath(ID)+"Focus.tscn"),ID)

	var event_ss = InputEventKey.new()
	event_ss.keycode = KEY_ENTER
	event_ss.command_or_control_autoremap = true
	HotkeyManager.register_hotkey("Focus start stop session","⌘⏎",event_ss,[],ID)

	var event_pu = InputEventKey.new()
	event_pu.keycode = KEY_P
	event_pu.shift_pressed = true
	event_pu.command_or_control_autoremap = true
	HotkeyManager.register_hotkey("Focus pause unpause session","⌘⇧P",event_pu,[],ID)

	var event_cp = InputEventKey.new()
	event_cp.keycode = KEY_N
	event_cp.shift_pressed = true
	event_cp.command_or_control_autoremap = true
	HotkeyManager.register_hotkey("Focus create project","⌘⇧N",event_cp,[],ID)

	var event_eg = InputEventKey.new()
	event_eg.keycode = KEY_S
	event_eg.shift_pressed = true
	event_eg.command_or_control_autoremap = true
	HotkeyManager.register_hotkey("Focus edit goal","⌘⇧P",event_eg,[],ID)

	Debug.log("Loaded!",ID)

func stop():
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)

	HotkeyManager.unregister_hotkey("focus_start_stop_session")
	HotkeyManager.unregister_hotkey("focus_pause_unpause_session")
	HotkeyManager.unregister_hotkey("focus_create_project")
	HotkeyManager.unregister_hotkey("focus_edit_goal")

	if CommandBar.command_exists(ID+"/Start Session"):
		CommandBar.remove_command(ID+"/Start Session")
	if CommandBar.command_exists(ID+"/Stop Session"):
		CommandBar.remove_command(ID+"/Stop Session")
	if CommandBar.command_exists(ID+"/Pause Session"):
		CommandBar.remove_command(ID+"/Pause Session")
	if CommandBar.command_exists(ID+"/Resume Session"):
		CommandBar.remove_command(ID+"/Resume Session")
