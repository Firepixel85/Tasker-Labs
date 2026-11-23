extends VBoxContainer
@onready var container: HFlowContainer = $HFlowContainer

func add_plugin(id:String):
	var plugin = load("res://PluginView/Plugin/PluginExplore.tscn").instantiate()
	container.add_child(plugin)
	await get_tree().process_frame
	plugin.setup(id)
