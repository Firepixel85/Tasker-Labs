extends Control
class_name RGRighClickMenu
@onready var item_container: VBoxContainer = $NinePatchRect/MarginContainer/VBoxContainer
@onready var texture: NinePatchRect = $NinePatchRect
@onready var selection: NinePatchRect = $NinePatchRect/MarginContainer/Control/NinePatchRect
var is_submenu:bool = false

func _ready() -> void:
	scale = Vector2(0,0)

func _custom_ready() -> void:
	if !is_submenu:
		grab_focus()
	create_tween().tween_property(self,"scale",Vector2(1,1),0.15*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SPRING)


func _on_focus_exited() -> void:
	RoseGarden._delete_all_menus()

func add_item(data:Array):
	var message
	match data[0]:
		"menu":
			message = _add_menu(data)
		"action":
			message = _add_action(data)
		"destructive":
			message = _add_destructive(data)
		"seperator":
			message = _add_seperator()
		_:
			return ERR_PARAMETER_RANGE_ERROR
	return message


func _add_menu(data:Array):
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count()-1)
	item.title = data[1]
	item.icon = data[2]
	item.menu = data[3]
	item.manager = self
	item.is_menu = true
	item.is_submenu = is_submenu
	item.update()
	_update()
	return OK

func _add_action(data:Array):
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count()-1)
	item.title = data[1]
	item.icon = data[2]
	item.action = data[3]
	item.action_params = data[4]
	item.is_submenu = is_submenu
	item.manager = self
	item.update()
	_update()
	return OK

func _add_destructive(data:Array):
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count()-1)
	item.title = data[1]
	item.icon = data[2]
	item.action = data[3]
	item.action_params = data[4]
	item.manager = self
	item.is_destructive = true
	item.is_submenu = is_submenu
	item.update()
	_update()
	return OK

func _add_seperator():
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_seperator.tscn").instantiate())
	_update()
	return OK

func _update():
	size.y  = item_container.get_minimum_size().y +16
	custom_minimum_size.y = size.y
	texture.size.y = size.y

func select_position(pos:int,destructive:bool=false):
	selection.position.y = pos
	if destructive:
		selection.modulate = Color("170707")
	else:
		selection.modulate = Color("414141")

func update_selection(is_menu:bool):
	if is_submenu:
		return
	if !is_menu:
		RoseGarden._delete_submenu_instantly()
