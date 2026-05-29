extends  Control

@onready var tabs: RGSegmentControl = $TopBar/HBoxContainer/MarginContainer/HBoxContainer/RGSegmentControl
@onready var main_view: Control = $".."
@onready var view_container: MarginContainer = $Container/ViewContainer

var selected_tab = "explore"
func _ready() -> void:
	tabs.add_item("explore","Explore")
	tabs.add_item("installed","Installed")

func _on_close_pressed() -> void:
	main_view.open_view("mainview")

func _process(_delta:float) -> void:
	if Input.is_action_just_pressed("1") and Input.is_key_pressed(KEY_META) and Main.get_current_view() == "plugins":
		tabs.select("explore")
	elif Input.is_action_just_pressed("2") and Input.is_key_pressed(KEY_META) and Main.get_current_view() == "plugins":
		tabs.select("installed")


func _on_tab_selected(item_name: String) -> void:
	if selected_tab == item_name:
		return
	if view_container.get_child_count()>0:
		view_container.get_child(0).queue_free()

	if item_name == "explore":
		selected_tab = "explore"
		return
	elif item_name == "installed":
		selected_tab = "installed"
		view_container.add_child(preload("res://Plugins/InstalledView.tscn").instantiate())
		view_container.get_child(0).display_plugins()

func setup():
	if selected_tab == "installed":
		view_container.get_child(0).display_plugins()
