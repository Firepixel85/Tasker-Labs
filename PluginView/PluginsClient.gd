extends  Control

@onready var tabs: RGSegmentControl = $TopBar/HBoxContainer/MarginContainer/HBoxContainer/RGSegmentControl
@onready var main_view: Control = $".."
@onready var view_container: HBoxContainer = $Container/MarginContainer/ViewScroll/ViewContainer
@onready var view_scroll: ScrollContainer = $Container/MarginContainer/ViewScroll
@onready var installed_view: Control = $Container/MarginContainer/ViewScroll/ViewContainer/InstalledView


#var selected_tab = "explore"
#func _ready() -> void:
	#tabs.add_item("explore","Explore")
	#tabs.add_item("installed","Installed")
	#get_tree().root.size_changed.connect(_resize_views)
#
#
#func _on_close_pressed() -> void:
	#main_view.open_view("mainview")
#
#func _process(_delta:float) -> void:
	#if Input.is_action_just_pressed("1") and Input.is_key_pressed(KEY_META) and Main.get_current_view() == "plugins":
		#tabs.select("explore")
	#elif Input.is_action_just_pressed("2") and Input.is_key_pressed(KEY_META) and Main.get_current_view() == "plugins":
		#tabs.select("installed")
	#if selected_tab == "explore":
		#view_scroll.set_deferred("scroll_horizontal", 0)
	#elif selected_tab == "installed":
		#view_scroll.set_deferred("scroll_horizontal", view_container.get_child(0).size.x+4)
#
#
#func _on_tab_selected(item_name: String) -> void:
	#if selected_tab == item_name:
		#return
	#if item_name == "explore":
		#selected_tab = "explore"
		#view_scroll.scroll_horizontal = 0
	#elif item_name == "installed":
		#selected_tab = "installed"
		#@warning_ignore("narrowing_conversion")
		#view_scroll.scroll_horizontal = view_scroll.size.x
		#view_container.get_child(1).refresh(false)
#
#func setup():
	#_resize_views()
#
#func _resize_views():
	#await get_tree().process_frame
	#for child in view_container.get_children():
		#child.custom_minimum_size.x = view_scroll.size.x

func setup():
	installed_view.refresh(false)
	_resize_views()

func _resize_views():
	await get_tree().process_frame
	for child in view_container.get_children():
		child.custom_minimum_size.x = view_scroll.size.x

func _ready() -> void:
	get_tree().root.size_changed.connect(_resize_views)

func _process(_delta:float) -> void:
	if PluginManager.get_all_plugins().size() == 0:
		view_scroll.set_deferred("scroll_horizontal", 0)
	else:
		view_scroll.set_deferred("scroll_horizontal", view_container.get_child(0).size.x+4)

func _on_close_pressed() -> void:
	main_view.open_view("mainview")
