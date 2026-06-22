extends Node

const ID = "com.rosepen.app_demo"

func start():
	Sidebar.add_tab("Focus",Icons.CHECKBOOK,load(PluginManager.get_plugin_filepath(ID)+"Scene.tscn"),ID)
	Debug.log("Loaded",ID)

func stop():
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)
