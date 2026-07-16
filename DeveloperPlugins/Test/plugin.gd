extends Node

const ID = "com.rosepen.dev_test"

func start():
	Sidebar.add_tab("API Test",Icons.FLASK,load(PluginManager.get_plugin_filepath(ID)+"TestPlugin.tscn"),ID)
	Debug.log("Loaded",ID)

func stop():
	if CommandBar.command_exists(ID+"/Push Notification"):
		CommandBar.remove_command(ID+"/Push Notification")
	if CommandBar.command_exists(ID+"/Open Settings"):
		CommandBar.remove_command(ID+"/Open Settings")
	if CommandBar.command_exists(ID+"/Open Plugins"):
		CommandBar.remove_command(ID+"/Open Plugins")
	if CommandBar.command_exists(ID+"/Test Command"):
		CommandBar.remove_command(ID+"/Test Command")
	if CommandBar.command_exists(ID+"/Create Toast"):
		CommandBar.remove_command(ID+"/Create Toast")
	Debug.log("Unloading",ID)
	Sidebar.remove_tab(ID)
