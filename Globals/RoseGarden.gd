extends Node

var menu_layer:CanvasLayer
var submenu:RGRighClickMenu
func set_menu_layer(layer:CanvasLayer):
	menu_layer = layer

func get_menu_layer():
	return menu_layer

@warning_ignore("unused_parameter")
func create_rc_menu(menu_layout:RGmenu,target_position:Vector2):
	menu_layer.add_child(preload("res://RG/Right Click Menu/RGRighClickMenu.tscn").instantiate())
	var menu:RGRighClickMenu = menu_layer.get_child(get_child_count()-1)
	var position = target_position
	
	for item in menu_layout.elements:
		await menu.add_item(item)
	
	if target_position.y+menu.size.y>DisplayServer.window_get_size().y:
		position.y = DisplayServer.window_get_size().y-menu.size.y-16
	if target_position.x +menu.size.x>DisplayServer.window_get_size().x:
		position.x = target_position.x-menu.size.x
	menu.position = position
	menu._custom_ready()
	return OK
	
func _create_rc_submenu(menu_layout:RGmenu,target_position:Vector2):
	menu_layer.add_child(preload("res://RG/Right Click Menu/RGRighClickMenu.tscn").instantiate())
	submenu = menu_layer.get_child(get_child_count()-1)
	submenu.is_submenu = true
	
	for item in menu_layout.elements:
		await submenu.add_item(item)
	
	target_position.x += submenu.size.x
	var position = target_position
	
	if target_position.y+submenu.size.y>DisplayServer.window_get_size().y:
		position.y = DisplayServer.window_get_size().y-submenu.size.y-16
	if target_position.x +submenu.size.x>DisplayServer.window_get_size().x:
		position.x = target_position.x-submenu.size.x*2
	submenu.position = position
	submenu._custom_ready()
	return OK

func _delete_submenu():
	for child in menu_layer.get_children():
		if child.is_submenu:
			child.modulate = Color(1,1,1,0)
	await get_tree().create_timer(0.3).timeout
	for child in menu_layer.get_children():
		if child.is_submenu:
			child.queue_free()
	submenu = null

func _delete_all_menus():
	var menus = menu_layer.get_children()
	for child in menus:
		child.modulate = Color(1,1,1,0)
	await get_tree().create_timer(0.3).timeout
	for child in menus:
		if child != null:
			child.queue_free()

func _delete_submenu_instantly():
	for child in menu_layer.get_children():
		if child.is_submenu:
			child.queue_free()
