extends Node

const ID = "com.rosepen.console"

func start():
	Sidebar.add_tab("Console",Icons.TERMINAL,preload("res://DeveloperPlugins/Console//Console.tscn"),ID)

func stop():
	Sidebar.remove_tab(ID)
