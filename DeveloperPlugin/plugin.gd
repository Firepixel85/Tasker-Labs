extends Node

const ID = "com.rosepen.console"
func start():
	Sidebar.add_tab("Console",RoseGarden.Icons.HOME,preload("res://DeveloperPlugin/Console.tscn"),ID)
