@tool
extends Node

func _ready() -> void:
	custom_themes_changed.connect(Themes._update_themes)
	await get_tree().create_timer(0.1).timeout
	custom_themes_changed.emit()
	enable_custom_themes("res://CustomThemes")

#Accessibility
class Accessibility:
	static var disableAnimations:bool = false
	static var increaseContrast:bool = false

	static func set_disable_animations(value:bool):
		disableAnimations = value

	static func set_increase_contrast(value:bool):
		increaseContrast = value

	static func get_disable_animations():
		return disableAnimations

	static func get_increase_contrast():
		return increaseContrast

#Colors
class Colors:

	const GRAY_HIGHLIGHT = Color("414141")
	const WHITE_HIGHLIGHT = Color("DADADA")
	const RED_HIGHLIGHT = Color("E74747")
	const ORANGE_HIGHLIGHT = Color("FBA051")
	const YELLOW_HIGHLIGHT = Color("FFDC58")
	const GREEN_HIGHLIGHT = Color("4BF14F")
	const TEAL_HIGHLIGHT = Color("8FFFF2")
	const BLUE_HIGHLIGHT = Color("4B9CED")
	const PINK_HIGHLIGHT = Color("FF85C4")
	const PURPLE_HIGHLIGHT = Color("935CF7")

	const GRAY = "Gray"
	const WHITE = "White"
	const RED = "Red"
	const ORANGE = "Orange"
	const YELLOW = "Yellow"
	const GREEN = "Green"
	const TEAL = "Teal"
	const BLUE = "Blue"
	const PINK = "Pink"
	const PURPLE = "Purple"

	const COLOR_NORMAL = Color(1,1,1)
	const COLOR_PRESSED = Color(0.65,0.65,0.65)
	const COLOR_HOVERED = Color(0.85,0.85,0.85)
	const COLOR_DISABLED = Color(0.6,0.6,0.6)
	const COLOR_DISABLED_HOVERED = Color(0.55,0.55,0.55)

	const TEXT_MAIN = Color("F5F5F5")
	const TEXT_SECONDARY = Color("ACACAC")
	const TEXT_DARK = Color("0A0A0A")

	static var _color_dic = {
		"Gray":Color("1D1D1D"),
		"White":Color("FDFDFD"),
		"Red":Color("D72D2C"),
		"Orange":Color("F7821C"),
		"Yellow":Color("FBC600"),
		"Green":Color("2AD62E"),
		"Teal":Color("49DAC9"),
		"Blue":Color("3993EC"),
		"Pink":Color("F167AE"),
		"Purple":Color("7A3FE7")
	}

	static func verify_color(color:String,use_easter_eggs:bool=false):
		if !use_easter_eggs:
			match color:
				"Gray","White","Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple":
					return OK
				_:
					return Error.ERR_INVALID_PARAMETER

		else:
			match color:
				"Gray","White","Red","Orange","Yellow","Green","Teal","Blue","Pink","Purple","Tasker":
					return OK
				_:
					return Error.ERR_INVALID_PARAMETER

	static func get_color(color:String):
		if !verify_color(color) == OK:
			return ERR_INVALID_PARAMETER
		return _color_dic[color]
#Icons
class Icons:
	const icons_path = "res://addons/RoseGarden/icons/"

	const HOME = preload(icons_path+"/Home.svg")
	const CHECKLIST = preload(icons_path+"/Checklist.svg")
	const BOOK = preload(icons_path+"/Book.svg")
	const TRASH = preload(icons_path+"/Trash.svg")
	const PREVIOUS = preload(icons_path+"/Previous.svg")
	const NEXT = preload(icons_path+"/Next.svg")
	const SCISSORS = preload(icons_path+"/Scissors.svg")
	const UP = preload(icons_path+"/Up.svg")
	const DOWN = preload(icons_path+"/DOWN.svg")
	const LOCK = preload(icons_path+"/Lock.svg")
	const SEARCH = preload(icons_path+"/Search.svg")

	static func get_icon(icon_name:String):
		if !FileAccess.file_exists(icons_path+icon_name+".svg"):
			return ERR_DOES_NOT_EXIST
		return load(icons_path+icon_name+".svg")

#Themes
class Themes:
	static var Main = load("res://addons/RoseGarden/themes/Main.tres")
	static var Secondary = load("res://addons/RoseGarden/themes/Secondary.tres")
	static var Large = load("res://addons/RoseGarden/themes/Large.tres")
	static var Info = load("res://addons/RoseGarden/themes/Info.tres")
	static var FinePrint = load("res://addons/RoseGarden/themes/FinePrint.tres")

	static func _update_themes():
		Main = load(RoseGarden._theme_path+"Main.tres")
		Secondary = load(RoseGarden._theme_path+"Secondary.tres")
		Large = load(RoseGarden._theme_path+"Large.tres")
		Info = load(RoseGarden._theme_path+"Info.tres")
		FinePrint = load(RoseGarden._theme_path+"FinePrint.tres")

#Custom Textures
var useCustomTextures:bool = false
var customTexturePath:String = ""
var _file_path:String = "res://addons/RoseGarden/components/"
signal custom_textures_changed

func set_custom_texture_path(path:String):
	if !FileAccess.file_exists(path):
		push_error("RoseGarden: The provided custom texture path does not exist.")
		return
	customTexturePath = path
	_file_path = path+"/"

func _get_file_path():
	return _file_path

func disable_custom_textures():
	useCustomTextures = false
	customTexturePath = ""
	_file_path = "res://addons/RoseGarden/components/"
	custom_textures_changed.emit()

func enable_custom_textures(file_path:String):
	useCustomTextures = true
	if !FileAccess.file_exists(file_path):
		push_error("RoseGarden: The provided custom texture path does not exist.")
	customTexturePath = file_path+"/"
	custom_textures_changed.emit()

#Fonts Themes
var useCustomThemes:bool = false
var customThemePath:String = ""
signal custom_themes_changed
var _theme_path:String = "res://addons/RoseGarden/themes/"

func set_use_custom_themes(value:bool):
	useCustomThemes = value

func set_custom_theme_path(file_path:String):
	if !FileAccess.file_exists(file_path):
		push_error("RoseGarden: The provided custom theme path does not exist.")
	customThemePath = file_path
	_theme_path = file_path+"/"
	custom_themes_changed.emit()

func enable_custom_themes(theme_path:String):
	useCustomThemes = true
	if !FileAccess.file_exists(theme_path):
		push_error("RoseGarden: The provided custom theme path does not exist.")
	customThemePath = theme_path
	_theme_path = theme_path+"/"
	custom_themes_changed.emit()

func disable_custom_themes():
	useCustomThemes = false
	customThemePath = ""
	_theme_path = "res://addons/RoseGarden/themes/"
	custom_themes_changed.emit()

func _get_theme_path():
	return _theme_path


#Right Click Menu Functions
var menu_layer:CanvasLayer
var submenu:RGRighClickMenu

func set_menu_layer(layer:CanvasLayer):
	menu_layer = layer

func get_menu_layer():
	return menu_layer

@warning_ignore("unused_parameter")
func create_rc_menu(menu_layout:RGmenu,target_position:Vector2):
	if menu_layer == null:
		return ERR_DOES_NOT_EXIST
	menu_layer.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGRighClickMenu.tscn").instantiate())
	var menu:RGRighClickMenu = menu_layer.get_child(get_child_count()-1)
	var position = target_position

	for item in menu_layout.elements:
		await menu.add_item(item)

	if target_position.y + menu.size.y > DisplayServer.window_get_size().y:
		position.y = target_position.y - menu.size.y
		menu.pivot_offset.y = menu.size.y
	if target_position.x +menu.size.x > DisplayServer.window_get_size().x:
		position.x = target_position.x - menu.size.x
		menu.pivot_offset.x = menu.size.x
	menu.position = position
	menu._custom_ready()
	return OK

func _create_rc_submenu(menu_layout:RGmenu,target_position:Vector2):
	if menu_layer == null:
		return ERR_DOES_NOT_EXIST
	menu_layer.add_child(preload("res://addons/RoseGarden/components/RightClickMenu/RGRighClickMenu.tscn").instantiate())
	submenu = menu_layer.get_child(get_child_count()-1)
	submenu.is_submenu = true

	for item in menu_layout.elements:
		await submenu.add_item(item)

	target_position.x += submenu.size.x
	var position = target_position

	if target_position.y + submenu.size.y > DisplayServer.window_get_size().y:
		position.y = DisplayServer.window_get_size().y - submenu.size.y - 16
	if target_position.x + submenu.size.x > DisplayServer.window_get_size().x:
		position.x = target_position.x - submenu.size.x*2 + 4
		submenu.pivot_offset.x = submenu.size.x
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
