extends Node

const ID = "com.rosepen.dataview"

func start():
	Sidebar.add_tab("DataView",load(PluginManager.get_plugin_filepath(ID)+"icon.png"),load(PluginManager.get_plugin_filepath(ID)+"DataView.tscn"),ID)
	var event_save = InputEventKey.new()
	
	event_save.keycode = KEY_S
	event_save.command_or_control_autoremap = true
	HotkeyManager.register_hotkey("Save changes","⌘S",event_save,["data","file"],ID)
	
	var event_delete = InputEventKey.new()
	event_delete.keycode = KEY_BACKSPACE
	event_delete.command_or_control_autoremap = true
	event_delete.shift_pressed = true
	HotkeyManager.register_hotkey("Delete file","⌘⇧⌫",event_delete,["data"],ID)
	
	Debug.log("Loaded!",ID)

func stop():
	Debug.log("Unloading...",ID)
	Sidebar.remove_tab(ID)
	HotkeyManager.unregister_hotkey("save_changes")
	HotkeyManager.unregister_hotkey("delete_file")
