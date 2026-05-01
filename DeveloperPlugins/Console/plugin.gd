extends Node

const ID = "com.rosepen.console"
func start():
	Sidebar.add_tab("Console",Icons.get_icon("Terminal"),preload("res://DeveloperPlugins/Console//Console.tscn"),ID)
