extends Control
@onready var project_container: VBoxContainer = $VBoxContainer/ScrollContainer/ProjectContainer

func add_project():
	project_container.add_child(load(PluginManager.get_plugin_filepath("com.rosepen.focus")+"Scenes/Project.tscn").instantiate())


func _on_add_project_pressed() -> void:
	add_project()
