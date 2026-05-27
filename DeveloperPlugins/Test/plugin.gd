extends Node

const ID = "com.rosepen.dev_test"

func start():
	Sidebar.add_tab("Dev Test",Icons.FLASK,load("res://DeveloperPlugins/Test/TestPlugin.tscn"),ID)

func stop():
	Sidebar.remove_tab(ID)
