extends Node

const ID = "com.rosepen.habits"

func start():
	Sidebar.add_tab("Habits",Icons.FLAME,load(PluginManager.get_plugin_filepath(ID)+"Habits.tscn"),ID)
	var event_ch := InputEventKey.new()
	event_ch.keycode = KEY_N
	event_ch.command_or_control_autoremap = true
	event_ch.shift_pressed = true
	HotkeyManager.register_hotkey("Create new habit","⌘⇧N",event_ch,[],ID)
	
	HotkeyManager.register_hotkey("Edit habit [n]","⇧[n]E",null,[],ID)
	HotkeyManager.register_hotkey("Freeze habit [n]","⇧[n]F",null,[],ID)
	HotkeyManager.register_hotkey("Delete habit [n]","⇧[n]D",null,[],ID)
	HotkeyManager.register_hotkey("Check in/out of habit [n]","⇧[n]C",null,[],ID)
	
	var event_e = InputEventKey.new()
	event_e.keycode = KEY_E
	InputMap.add_action("E")
	InputMap.action_add_event("E", event_e)

	var event_f = InputEventKey.new()
	event_f.keycode = KEY_F
	InputMap.add_action("F")
	InputMap.action_add_event("F", event_f)
	
	var event_d = InputEventKey.new()
	event_d.keycode = KEY_D
	InputMap.add_action("D")
	InputMap.action_add_event("D", event_d)
	
	var event_c = InputEventKey.new()
	event_c.keycode = KEY_C
	InputMap.add_action("C")
	InputMap.action_add_event("C", event_c)
	
	
	Debug.log("Loaded",ID)

func stop():
	HotkeyManager.unregister_hotkey("create_new_habit")
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)
