extends Control
class_name RGRighClickMenu
@onready var item_container: VBoxContainer = $NinePatchRect/MarginContainer/VBoxContainer
@onready var texture: NinePatchRect = $NinePatchRect
@onready var selection: NinePatchRect = $NinePatchRect/MarginContainer/Control/NinePatchRect
var is_submenu: bool = false
var _mouse_inside := false
var grace_period := true
var mouse_was_inside: bool = false


func _ready() -> void:
	RoseGarden.custom_textures_changed.connect(_update)
	scale = Vector2(0, 0)
	await get_tree().create_timer(0.1).timeout
	grace_period = false
	grab_focus()


func _custom_ready() -> void:
	if !is_submenu:
		grab_focus()
		(create_tween() . tween_property( self, "scale", Vector2(1, 1), ( 0.15 * int(!RoseGarden.Accessibility.get_disable_animations()) * int(RoseGarden.Animations.rcmAppearance) ) ) . set_trans(Tween.TRANS_SPRING))
	else:
		scale = Vector2(1, 1)
	if item_container.get_child(0).is_destructive:
		selection.modulate = Color("17070700")
	else:
		selection.modulate = Color("41414100")


func _on_focus_exited() -> void:
	await get_tree().process_frame
	if grace_period or get_viewport().gui_get_focus_owner().has_method("_add_destructive"):  #"_add_destructive" is a method specific to the RGRighClickMenuItem class, which is used for menu items. This check ensures that the focus owner is a menu item before proceeding with the deletion of menus.
		return
	RoseGarden._delete_all_menus()


func add_item(data: Array):
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


func _add_menu(data: Array):
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count() - 1)
	item.title = data[1]
	item.icon = data[2]
	item.menu = data[3]
	item.manager = self
	item.is_menu = true
	item.is_submenu = is_submenu
	item.update()
	_update()
	return OK


func _add_action(data: Array):
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count() - 1)
	item.title = data[1]
	item.icon = data[2]
	item.action = data[3]
	item.action_params = data[4]
	item.is_submenu = is_submenu
	item.manager = self
	item.update()
	_update()
	return OK


func _add_destructive(data: Array):
	item_container.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_item.tscn").instantiate())
	var item = item_container.get_child(item_container.get_child_count() - 1)
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
	item_container.add_child(( preload("res://addons/RoseGarden/components/RightClickMenu/RGrcm_seperator.tscn") . instantiate() ))
	_update()
	return OK


func _update():
	texture.texture = load(RoseGarden._get_file_path() + "RightClickMenu/Container.svg")
	selection.texture = load(RoseGarden._get_file_path() + "RightClickMenu/Selection.svg")
	size.y = item_container.get_minimum_size().y + 16
	custom_minimum_size.y = size.y
	texture.size.y = size.y


func select_position(pos: int, destructive: bool = false):
	if destructive:
		selection.modulate = Color("170707")
	else:
		selection.modulate = Color("414141")
	var tween = create_tween()
	(tween . tween_property( selection, "position:y", pos, ( 0.07 * int(!RoseGarden.Accessibility.disableAnimations) * int(RoseGarden.Animations.rcmSelection) ) ) . set_ease(Tween.EASE_OUT) . set_trans(Tween.TRANS_CUBIC))
	await get_tree().create_timer(0.1).timeout
	if destructive:
		selection.modulate = Color("170707")
	else:
		selection.modulate = Color("414141")


func update_selection(is_menu: bool):
	if is_submenu:
		return
	if !is_menu:
		RoseGarden._delete_submenu_instantly()


func _on_mouse_entered() -> void:
	create_tween().tween_property(selection, "modulate", Color(selection.modulate.r, selection.modulate.g, selection.modulate.b, 1), ( 0.07 * int(!RoseGarden.Accessibility.disableAnimations) * int(RoseGarden.Animations.rcmSelection) ))


func _on_mouse_exited() -> void:
	create_tween().tween_property(selection, "modulate", Color(selection.modulate.r, selection.modulate.g, selection.modulate.b, 0), ( 0.07 * int(!RoseGarden.Accessibility.disableAnimations) * int(RoseGarden.Animations.rcmSelection) ))


func _process(_delta: float) -> void:
	if mouse_was_inside and !is_mouse_inside():
		_on_mouse_exited()
	elif !mouse_was_inside and is_mouse_inside():
		_on_mouse_entered()
	elif !mouse_was_inside and !is_mouse_inside():
		_on_mouse_exited()
	mouse_was_inside = is_mouse_inside()


func is_mouse_inside() -> bool:
	var mouse_pos = get_global_mouse_position()
	if (mouse_pos.x < position.x or mouse_pos.y < position.y or mouse_pos.x > position.x + size.x or mouse_pos.y > position.y + size.y):
		return false
	return true
