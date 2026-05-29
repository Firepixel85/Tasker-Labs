extends Node

const ID = "com.rosepen.dev_test"

func start():
	Sidebar.add_tab("API Test",Icons.FLASK,load("res://DeveloperPlugins/Test/TestPlugin.tscn"),ID)
	Debug.log("Loaded",ID)

func stop():
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)
