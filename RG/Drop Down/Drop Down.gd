@tool
extends Control
class_name DropDown
@onready var label: Label = $NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var container: NinePatchRect = $NinePatchRect
@onready var menu_container: NinePatchRect = $NinePatchRect2
@onready var menu_item_container: VBoxContainer = $NinePatchRect2/MarginContainer/VBoxContainer
@onready var button: Button = $Button

var items:Array = []
var item_ids:Array = []
var last_given_id:int = -1
var selected:int = 0
var _is_open:bool = false
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		#_update()
		pass

func _update():
	if !Engine.is_editor_hint():
		size.x = menu_item_container._get_min_size()
		if !_array_has_item(item_ids,selected) and item_ids !=[]:
			selected = item_ids[0]
	container.size = size
	custom_minimum_size = Vector2(label.size.x+35,30)
	menu_container.size = Vector2(size.x,menu_item_container.get_child_count()*21.5)
	menu_container.custom_minimum_size.x = size.x
	#position = Vector2(0,0)
	button.custom_minimum_size = size

	label.text = items[_find_index(item_ids,selected)]

func add_item(item_name:String,item_id:int):
	if _array_has_item(item_ids,item_id):
		return Error.ERR_ALREADY_EXISTS
	items.append(item_name)
	item_ids.append(item_id)
	menu_item_container.add_child(preload("res://RG/Drop Down/Menu Item/menu_item.tscn").instantiate())
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
	for child in menu_item_container.get_children():
		child._update()
	menu_container.visible=true
	_update()

func _close():
	menu_container.visible=false
	button.grab_focus()

func _pressed() -> void:
	_open()

func select(item_id:int):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	selected = _find_index(item_ids,item_id)
	_update()


func _on_focus_exited() -> void:
	_close()


func _new_menu_item(node: Node) -> void:
	await node._updated
	_update()
