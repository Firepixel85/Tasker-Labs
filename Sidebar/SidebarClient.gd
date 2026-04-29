extends Control

@onready var tab_container: VBoxContainer = $TabButtons/ScrollContainer/VBoxContainer
@onready var selection: NinePatchRect = $Selection
@onready var scene_container: Control = $"../../../../VBoxContainer2/SceneContainer"

const id = "core.sidebar"
var tabs = []
var _tab_scenes = {}
var selected:String 

func _add_tab(title:String,icon:Texture2D,scene:Resource,tab_id:String):
	if tabs.has(tab_id):
		return ERR_ALREADY_EXISTS
	tabs.append(tab_id)
	_tab_scenes[tab_id] = scene
	tab_container.add_child(Button.new())
	var tab:Button = tab_container.get_child(tab_container.get_child_count()-1)
	tab.set_script(preload("res://Sidebar/TabButton.gd"))
	tab.text = title
	tab.icon = icon
	tab.flat = true
	tab.alignment = HORIZONTAL_ALIGNMENT_LEFT
	tab.theme = preload("res://CustomThemes/Main.tres")
	tab.add_theme_stylebox_override("Focus",StyleBoxEmpty.new())
	tab.manager = self
	tab.id = tab_id
	tab._ready()
	if selected == "":
		selected = tabs[0]
		scene_container.add_child(_tab_scenes[tabs[0]].instantiate())
	_shade_tabs()
	Debug.log("Tab added by process: "+Main.get_process_name(tab_id),id)
	return OK

func _remove_tab(tab_id:String):
	if !tabs.has(tab_id):
		return ERR_DOES_NOT_EXIST
	for child in tab_container.get_children():
		if child.id == tab_id:
			child.queue_free()
			tabs.remove_at(_find_index(tabs,tab_id))
			_tab_scenes.erase(tab_id)
			if selected == tab_id:
				selected = tabs[0]
			_shade_tabs()
			break
	return OK

func _ready() -> void:
	Sidebar._client = self
	Sidebar.ready.emit()


func _find_index(array:Array,item):
	var index = 0
	for i in array.size():
		if array[i] == item:
			index = i
	return index

func _select(selection_id:String):
	if !tabs.has(selection_id):
		return ERR_DOES_NOT_EXIST
	selected = selection_id
	selection.visible = true
	create_tween().tween_property(selection,"position",Vector2(selection.position.x,80*_find_index(tabs,selection_id)),0.15*int(Sidebar.doAnimation)*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_shade_tabs()
	if scene_container.get_child_count()>0:
		scene_container.get_child(0).queue_free()
	scene_container.add_child(_tab_scenes[selection_id].instantiate())
	Sidebar.tab_selected.emit(selection_id)
	return OK

func _shade_tabs():
	for child in tab_container.get_children():
		if child.id == selected:
			child.modulate = RoseGarden.Colors.TEXT_MAIN
		else:
			child.modulate = RoseGarden.Colors.TEXT_SECONDARY
	
