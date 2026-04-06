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
	menu_item_container.add_child(preload("res://RG/Drop Down/Menu Item/RGmenu_item.tscn").instantiate())
	var target:Control = menu_item_container.get_children()[menu_item_container.get_children().size() - 1]
	target.manager = self
	target.id = item_id
	target.option_name = item_name
	target._ready()
	_update()
	_open()
	_close()
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
	return OK

func select(item_id:int):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	selected = item_id
	new_selection.emit(items[item_id])
	_update()
	return OK

func get_selected():
	return selected

func get_selected_item():
	return items[_find_index(item_ids,selected)]

##############
#### STOP #### Here begin private function that should never be called by your code
##############

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
	menu_container.visible=true
	_update()
	selection.visible = true
	opened.emit()

func _close():
	var tween = create_tween()
	selection.visible = false
	tween.tween_property(menu_container,"size",size,0.07*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.07).timeout
	menu_container.visible=false
	closed.emit()

func _pressed() -> void:
	_open()

func _new_menu_item(node: Node) -> void:
	await node._updated
	_update()

func _on_menu_item_highlighted(id: int) -> void:
	create_tween().tween_property(selection,"position",Vector2(selection.position.x,52*_find_index(item_ids,id)),0.09*int(not(RoseGarden.Accessibility.get_disable_animations() or instant_selection))).set_trans(Tween.TRANS_SPRING)


func _on_focus_exited() -> void:
	await get_tree().create_timer(0.1).timeout
	if !has_focus():
		_close()


func _on_mouse_entered() -> void:
	modulate = Colors.COLOR_HOVERED


func _on_mouse_exited() -> void:
	modulate = Colors.COLOR_NORMAL


func _on_button_up() -> void:
	modulate = Colors.COLOR_HOVERED


func _on_button_down() -> void:
	modulate = Colors.COLOR_PRESSED
