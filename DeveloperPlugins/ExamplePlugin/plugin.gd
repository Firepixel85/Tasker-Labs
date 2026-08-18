extends Node

const ID = "com.[your_name].[plugin_name]"

func start():
	Sidebar.add_tab(
	"Example Plugin",
	PluginManager.get_plugin_icon(ID),
	load(PluginManager.get_plugin_filepath(ID)+"example_scene.tscn"),
	ID
	)

func stop():
	Sidebar.remove_tab(ID)
