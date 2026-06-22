extends Control

@onready var tab_container: VBoxContainer = $TabButtons/ScrollContainer/VBoxContainer
@onready var selection: NinePatchRect = $Selection
@onready var scene_container: Control = $"../../../../VBoxContainer2/SceneContainer"
@onready var scroll_container: ScrollContainer = $TabButtons/ScrollContainer

const ID := "core.sidebar"
var tabs := []
var _tab_scenes := {}
var _tab_scene_nodes := {}
var selected:String
var selected_node:Button
var past_scroll:int = 0

func _add_tab(title:String,icon:Texture2D,scene:Resource,tab_id:String):
	if tabs.has(tab_id):
		Debug.warn("Process: "+Main.get_process_name(tab_id)+" attempted to add a tab with an id that already exists: "+tab_id,ID)
		return ERR_ALREADY_EXISTS
	tabs.append(tab_id)
	_tab_scenes[tab_id] = scene
	tab_container.add_child(Button.new())
	var tab:Button = tab_container.get_child(tab_container.get_child_count()-1)
	tab.set_script(preload("res://Sidebar/TabButton.gd"))
	tab.name = tab_id
	tab.text = title
	tab.icon = icon
	tab.flat = true
	tab.custom_minimum_size.y = 56
	tab.alignment = HORIZONTAL_ALIGNMENT_LEFT
	tab.theme = preload("res://CustomThemes/Main.tres")
	tab.add_theme_stylebox_override("Focus",StyleBoxEmpty.new())
	tab.manager = self
	tab.id = tab_id

	tab._ready()
	scene_container.add_child(scene.instantiate())
	_tab_scene_nodes[tab_id] = scene_container.get_child(scene_container.get_child_count()-1)
	_tab_scene_nodes[tab_id].hide()
	if selected == "":
		selected_node = tab
		selection.visible = true
		selected = tabs[0]
		for child in scene_container.get_children():
			child.hide()
		_tab_scene_nodes[tab_id].show()
	_shade_tabs()
	Debug.log("Tab added by process: "+Main.get_process_name(tab_id),ID)
	return OK

func _remove_tab(tab_id:String):
	if !tabs.has(tab_id):
		Debug.warn("Process: "+Main.get_process_name(tab_id)+" attempted to remove a tab with an id that does not exist: "+tab_id,ID)
		return ERR_DOES_NOT_EXIST
	for child in tab_container.get_children():
		if child.id == tab_id:
			child.queue_free()
			tabs.remove_at(_find_index(tabs,tab_id))
			_tab_scenes.erase(tab_id)
			_tab_scene_nodes[tab_id].queue_free()
			_tab_scene_nodes.erase(tab_id)
			if selected == tab_id:
				if tabs.size()>0:
					_select(tabs[0])
				else:
					selected = ""
					_ready()
			break
		_select(selected)
		_shade_tabs()
	return OK

func _ready() -> void:
	Sidebar._client = self
	selection.visible = false
	scene_container.add_child(preload("res://Sidebar/NoPluginsLoaded.tscn").instantiate())
	Sidebar.ready.emit()


func _find_index(array:Array,item):
	var index = 0
	for i in array.size():
		if array[i] == item:
			index = i
	return index

func _select(selection_id:String):
	if !tabs.has(selection_id):
		Debug.warn("Process: "+Main.get_process_name(selection_id)+" attempted to select a tab with an id that does not exist: "+selection_id,ID)
		return ERR_DOES_NOT_EXIST
	selected = selection_id
	selection.show()
	for child in tab_container.get_children():
		if child.id == selection_id:
			selected_node = child
	create_tween().tween_property(selection,"position:y",
		80*_find_index(tabs,selection_id),
		0.15*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_shade_tabs()
	for child in scene_container.get_children():
		child.hide()
	_tab_scene_nodes[selection_id].show()
	Sidebar.tab_selected.emit(selection_id)
	return OK

func _shade_tabs():
	for child in tab_container.get_children():
		if child.id == selected:
			child.modulate = RoseGarden.Colors.TEXT_MAIN
		else:
			child.modulate = RoseGarden.Colors.TEXT_SECONDARY

func _process(_delta:float) -> void:
	if Main.get_current_view() != "mainview":
		return
	for i in range(9):
		if Input.is_action_just_pressed(str(i+1)) and Input.is_key_pressed(KEY_META) and tab_container.get_child_count()>i:
			_select(tabs[i])
	if past_scroll != scroll_container.scroll_vertical:
		selection.position.y = selected_node.get_global_transform().origin.y-116
	past_scroll = scroll_container.scroll_vertical
