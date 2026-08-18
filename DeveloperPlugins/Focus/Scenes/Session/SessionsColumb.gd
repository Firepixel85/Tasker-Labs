extends Control
@onready var session_container: VBoxContainer = $VBoxContainer/ScrollContainer/SessionContainer

func add_session_interface():
	var session = load(PluginManager.get_plugin_filepath("com.rosepen.focus")+"Scenes/Session/Session.tscn").instantiate()
	session_container.add_child(session)
	return session
