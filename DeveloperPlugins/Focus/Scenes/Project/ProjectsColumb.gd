extends Control
@onready var project_container: VBoxContainer = $VBoxContainer/ScrollContainer/ProjectContainer
@onready var add_project: RGButton = $VBoxContainer/HBoxContainer/AddProject

func add_project_interface(project:FocusProject):
	var interface = load(PluginManager.get_plugin_filepath("com.rosepen.focus")+"Scenes/Project/Project.tscn").instantiate()
	project_container.add_child(interface)
	interface.setup(project)

func update_project_visibility(project:String):
	for proj in project_container.get_children():
		proj.update_visibility(project)
