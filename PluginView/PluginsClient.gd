extends  Control

@onready var view_select: RGSegmentControl = $TopBar/HBoxContainer/MarginContainer/HBoxContainer/ViewSelect
@onready var main_view: Control = $".."
@onready var view_container: HBoxContainer = $Container/MarginContainer/ViewScroll/ViewContainer
@onready var view_scroll: ScrollContainer = $Container/MarginContainer/ViewScroll
@onready var installed_view: Control = $Container/MarginContainer/ViewScroll/ViewContainer/InstalledView
@onready var explore_view: Control = $Container/MarginContainer/ViewScroll/ViewContainer/ExploreView


var selected_tab := "explore"

func setup():
	installed_view.refresh(false)
	_resize_views()

func _resize_views():
	await get_tree().process_frame
	for child in view_container.get_children():
		child.custom_minimum_size.x = view_scroll.size.x

func _ready() -> void:
	view_select.add_item("explore","Explore")
	view_select.add_item("installed","Installed")
	get_tree().root.size_changed.connect(_resize_views)

#func _process(_delta:float) -> void:
#	if PluginManager.get_all_plugins().size() == 0:
#		view_scroll.set_deferred("scroll_horizontal", 0)
#	else:
#		view_scroll.set_deferred("scroll_horizontal", view_container.get_child(0).size.x+4)

func _on_close_pressed() -> void:
	main_view.open_view("mainview")


func _on_view_selected(tab_name: String) -> void:
	if tab_name == selected_tab:
		return
	if tab_name == "installed":
		#installed_view.show()
		var tween = create_tween()
		tween.tween_property(view_scroll,"scroll_horizontal",view_container.get_child(1).position.x,0.2*int(!RoseGarden.Accessibility.get_disable_animations())*int(RoseGarden.Animations.ddmSelection)).set_trans(Tween.TRANS_SINE)
		await tween.finished
		#explore_view.hide()
	elif tab_name == "explore":
		#explore_view.show()
		view_scroll.set_deferred("scroll_horizontal", view_container.get_child(1).position.x)
		var tween = create_tween()
		tween.tween_property(view_scroll,"scroll_horizontal",view_container.get_child(0).position.x,0.2*int(!RoseGarden.Accessibility.get_disable_animations())*int(RoseGarden.Animations.ddmSelection)).set_trans(Tween.TRANS_SINE)
		await tween.finished
		#installed_view.hide()
	selected_tab = tab_name

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("1") and Input.is_key_pressed(KEY_META):
		view_select.select("explore")
		get_viewport().set_input_as_handled()
	elif Input.is_action_just_pressed("2") and Input.is_key_pressed(KEY_META):
		view_select.select("installed")
		get_viewport().set_input_as_handled()
