@tool
extends Control
@onready var label: Label = $NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var container: NinePatchRect = $NinePatchRect
@onready var menu_container: NinePatchRect = $NinePatchRect2
@onready var menu_item_container: VBoxContainer = $NinePatchRect2/MarginContainer/VBoxContainer

@export var items:Array = ["test"]

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_update()

func _update():
	custom_minimum_size = Vector2(label.size.x+35,30)
	menu_container.size.y = menu_item_container.get_child_count()*21.5
	container.size.x = size.x

func add_item(item_name:String):
	if _array_has_item(items,item_name):
		return
	items.append(item_name)
	var id = _find_index(items,item_name)
	menu_item_container.add_child(preload("res://RG/Drop Down/Menu Item/menu_item.tscn").instantiate())
	var target:Control = menu_item_container.get_children()[menu_item_container.get_children().size() - 1]
	target.manager = self
	target.id = id
	return id

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
