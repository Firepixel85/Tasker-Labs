extends Control
class_name RGRighClickMenu
@onready var item_container: VBoxContainer = $NinePatchRect/MarginContainer/VBoxContainer
@onready var texture: NinePatchRect = $NinePatchRect
@onready var selection: NinePatchRect = $NinePatchRect/MarginContainer/Control/NinePatchRect

func _ready() -> void:
	grab_focus()

func _on_focus_exited() -> void:
	modulate = Color(0,0,0,0)
	await get_tree().create_timer(0.3).timeout
	queue_free()

func add_item(data:Array):
	match data[0]:
		"menu":
			await  _add_menu(data)
		"action":
			await _add_action(data)
		"destructive":
			await _add_destructive(data)
		_:
			return ERR_PARAMETER_RANGE_ERROR
	return OK
		
		
func _add_menu(data:Array):
	item_container.add_child(preload("res://RG/Right Click Menu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count()-1)
	item.title = data[1]
	item.icon = data[2]
	item.manager = self
	item.is_menu = true
	item.update()
	_update()
	return OK
	
func _add_action(data:Array):
	item_container.add_child(preload("res://RG/Right Click Menu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count()-1)
	item.title = data[1]
	item.icon = data[2]
	item.action = data[3]
	item.action_params = data[4]
	item.manager = self
	item.update()
	_update()
	return OK

func _add_destructive(data:Array):
	item_container.add_child(preload("res://RG/Right Click Menu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count()-1)
	item.title = data[1]
	item.icon = data[2]
	item.action = data[3]
	item.action_params = data[4]
	item.manager = self
	item.is_destructive = true
	item.update()
	_update()
	return OK

func _update():
	size.y = item_container.get_child_count()*68 +8
	custom_minimum_size.y = item_container.get_child_count()*68 +8
	texture.size.y = size.y

func select_position(pos:int,destructive:bool=false):
	selection.position.y = pos
	if destructive:
		selection.modulate = Color("170707")
	else:
		selection.modulate = Color("414141")
