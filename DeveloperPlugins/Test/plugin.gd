extends Node

const ID = "com.rosepen.dev_test"

func start():
	Sidebar.add_tab("API Test",Icons.FLASK,load("res://DeveloperPlugins/Test/TestPlugin.tscn"),ID)

func stop():
	Sidebar.remove_tab(ID)
