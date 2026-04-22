@tool
extends Control
class_name RGDropDown
@onready var label: Label = $NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var container: NinePatchRect = $NinePatchRect
@onready var menu_container: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var menu_item_container: VBoxContainer = $CanvasLayer/NinePatchRect2/MarginContainer/VBoxContainer
@onready var button: Button = $Button
@onready var selection: NinePatchRect = $CanvasLayer/NinePatchRect2/SelectionContainer/Container/Selection
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var arrow: TextureRect = $NinePatchRect/MarginContainer/HBoxContainer2/VBoxContainer/TextureRect

@export var instant_selection:bool = false##Instantly move the selection to the hovered item with no animation
var items:Array = []
var item_ids:Array = []
var last_given_id:int = -1
var selected:int = 0
signal new_selection(selection:String)
signal opened
signal closed

func add_item(item_name:String,item_id:int):
	if _array_has_item(item_ids,item_id):
		return Error.ERR_ALREADY_EXISTS
	items.append(item_name)
	item_ids.append(item_id)
	menu_item_container.add_child(preload("res://addons/RoseGarden/components/DropDown/Menu Item/RGmenu_item.tscn").instantiate())
	var target:Control = menu_item_container.get_children()[menu_item_container.get_children().size() - 1]
	target.manager = self
	target.id = item_id
	target.option_name = item_name
	target._ready()
	_update()
	menu_container.modulate = Color(1,1,1,0)
	_open()
	_close(true)
	menu_container.modulate = Color(1,1,1,1)
	return OK

func remove_item(item_id:int):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	items.remove_at(_find_index(item_ids,item_id))
	item_ids.remove_at(_find_index(item_ids,item_id))
	for child in menu_item_container.get_children():
		if child.id == item_id:
			child.queue_free()
	_update()
	selection.position.y = 0
	return OK

func select(item_id:int):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	selected = item_id
	new_selection.emit(items[_find_index(item_ids,item_id)])
	_update()
	return OK

func get_selected():
	return selected

func get_selected_item():
	return items[_find_index(item_ids,selected)]

##############
#### STOP #### Here begin private functions that should never be called by your code
##############
##
func _ready() -> void:
	RoseGarden.custom_textures_changed.connect(_update_textures)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update_textures()
	_update_themes()

func _update():
	if !Engine.is_editor_hint():
		size.x = menu_item_container._get_min_size()
		if !_array_has_item(item_ids,selected) and item_ids !=[]:
			selected = item_ids[0]
	container.size = size
	menu_container.size = size
	custom_minimum_size = size
	create_tween().tween_property(menu_container,"size",Vector2(size.x,(menu_item_container.get_child_count()*52)+12),0.07*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
	menu_container.custom_minimum_size.x = size.x
	button.custom_minimum_size = size
	label.text = items[_find_index(item_ids,selected)]



func _array_has_item(array:Array,item):
	var found := false
	for part in array:
		if part == item:
			found = true
			break
	return found

func _find_index(array:Array,item):
	var index = 0
	for i in array.size():
		if array[i] == item:
			index = i
	return index

func _open():
	menu_container.position = global_position
	for child in menu_item_container.get_children():
		child._update()
		if _find_index(item_ids,child.id) == 0:
			child.highlighted = true
	menu_container.visible=true
	_update()
	selection.visible = true
	opened.emit()

func _close(invisible:bool=false):
	var tween = create_tween()
	selection.visible = false
	tween.tween_property(menu_container,"size",size,0.07*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.07*int(!invisible)).timeout
	menu_container.visible=false
	closed.emit()

func _pressed() -> void:
	_open()

func _new_menu_item(node: Node) -> void:
	await node._updated
	_update()

func _on_menu_item_highlighted(id: int) -> void:
	selection.visible = true
	create_tween().tween_property(selection,"position",Vector2(selection.position.x,52*_find_index(item_ids,id)),0.09*int(not(RoseGarden.Accessibility.get_disable_animations() or instant_selection))).set_trans(Tween.TRANS_SPRING)


func _on_focus_exited() -> void:
	await get_tree().create_timer(0.1).timeout
	if !has_focus():
		_close()


func _on_mouse_entered() -> void:
	modulate = RoseGarden.Colors.COLOR_HOVERED


func _on_mouse_exited() -> void:
	modulate = RoseGarden.Colors.COLOR_NORMAL


func _on_button_up() -> void:
	modulate = RoseGarden.Colors.COLOR_HOVERED


func _on_button_down() -> void:
	modulate = RoseGarden.Colors.COLOR_PRESSED

func _update_textures():
	container.texture = load(RoseGarden._file_path+"DropDown/Container.svg")
	arrow.texture = load(RoseGarden._file_path+"DropDown/Arrow.svg")
	menu_container.texture = load(RoseGarden._file_path+"DropDown/Container.svg")
	selection.texture = load(RoseGarden._file_path+"DropDown/Selection.svg")

func _update_themes():
	label.theme = RoseGarden.Themes.Secondary
