extends Control
@onready var session_container: VBoxContainer = $VBoxContainer/ScrollContainer/SessionContainer

func add_session():
	session_container.add_child(load(PluginManager.get_plugin_filepath("com.rosepen.focus")+"Scenes/Session.tscn").instantiate())
