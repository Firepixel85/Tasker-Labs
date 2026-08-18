extends Node

const ID = "com.rosepen.focus"

func start():
	Sidebar.add_tab("Focus",Icons.CHECKBOOK,load(PluginManager.get_plugin_filepath(ID)+"Focus.tscn"),ID)

	if not InputMap.has_action("focus_start_stop_session"):
		InputMap.add_action("focus_start_stop_session")
	var event = InputEventKey.new()
	event.keycode = KEY_ENTER
	event.command_or_control_autoremap = true
	InputMap.action_add_event("focus_start_stop_session", event)
	if not InputMap.has_action("focus_pause_unpause_session"):
		InputMap.add_action("focus_pause_unpause_session")
	event = InputEventKey.new()
	event.keycode = KEY_P
	event.command_or_control_autoremap = true
	event.shift_pressed = true
	InputMap.action_add_event("focus_pause_unpause_session", event)
	if not InputMap.has_action("focus_create_project"):
		InputMap.add_action("focus_create_project")
	event = InputEventKey.new()
	event.keycode = KEY_N
	event.command_or_control_autoremap = true
	event.shift_pressed = true
	InputMap.action_add_event("focus_create_project", event)

	Debug.log("Loaded!",ID)

func stop():
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)

	if InputMap.has_action("focus_start_stop_session"):
		InputMap.erase_action("focus_start_stop_session")
	if InputMap.has_action("focus_pause_unpause_session"):
		InputMap.erase_action("focus_pause_unpause_session")
	if InputMap.has_action("focus_create_project"):
		InputMap.erase_action("focus_create_project")
