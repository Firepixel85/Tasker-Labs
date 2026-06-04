extends Node

const ID = "com.rosepen.console"

func start():
	if !Settings.category_exists(ID):
		Settings.add_category("Console","res://Icons/Terminal.svg",ID)
	else:
		Settings.show_category(ID)
	if !Settings.option_exists("com.rosepen.console/show_timestamps"):
		Settings.add_option(ID,"show_timestamps",PluginManager.get_plugin_filepath(ID)+"Console/Settings/ShowTimestamps/ShowTimestamps.tscn",false)
	Sidebar.add_tab("Console",Icons.TERMINAL,load(PluginManager.get_plugin_filepath(ID)+"Console//Console.tscn"),ID)
	Debug.log("Loaded",ID)

func stop():
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)
	Settings.hide_category(ID)
