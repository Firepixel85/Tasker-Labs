extends Node

const ID = "com.rosepen.console"

func start():
	if !Settings.category_exists("com.rosepen.console"):
		Settings.add_category("Console","res://Icons/Terminal.svg","com.rosepen.console")
	else:
		Settings.show_category("com.rosepen.console")
	if !Settings.option_exists("com.rosepen.console/show_timestamps"):
		Settings.add_option("com.rosepen.console","show_timestamps","res://DeveloperPlugins/Console/Settings/ShowTimestamps/ShowTimestamps.tscn",false)
	Sidebar.add_tab("Console",Icons.TERMINAL,preload("res://DeveloperPlugins/Console//Console.tscn"),ID)

func stop():
	Sidebar.remove_tab(ID)
	Settings.hide_category("com.rosepen.console")
