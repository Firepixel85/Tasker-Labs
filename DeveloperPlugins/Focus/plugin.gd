extends Node

const ID = "com.rosepen.focus"

func start():
	Sidebar.add_tab("Focus",Icons.CHECKBOOK,load(PluginManager.get_plugin_filepath(ID)+"Focus.tscn"),ID)
	Debug.log("Loaded!",ID)
	
func stop():
	Debug.log("Unloading",ID)
