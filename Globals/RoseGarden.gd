extends Node

var menu_layer:CanvasLayer

func set_menu_layer(layer:CanvasLayer):
	menu_layer = layer

func get_menu_layer():
	return menu_layer

@warning_ignore("unused_parameter")
func create_rc_menu(menu_layout:RGmenu,target_position:Vector2):
	menu_layer.add_child(preload("res://RG/Right Click Menu/RGRighClickMenu.tscn").instantiate())
	var menu:RGRighClickMenu = menu_layer.get_child(get_child_count()-1)
	var position = target_position
	
	if target_position.y+menu.size.y>DisplayServer.window_get_size().y:
		position.y = DisplayServer.window_get_size().y-menu.size.y
	if target_position.x +menu.size.x>DisplayServer.window_get_size().x:
		position.x = target_position.x-menu.size.x
	
	menu.position = position
