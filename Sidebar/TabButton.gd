extends Button

var id: String
var manager


func _pressed() -> void:
	if manager.selected == id:
		return
	manager._select(id)


func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _mouse_entered():
	modulate = RoseGarden.Colors.TEXT_MAIN


func _mouse_exited():
	if !manager.selected == id:
		modulate = RoseGarden.Colors.TEXT_SECONDARY


func _gui_input(event: InputEvent):
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_MASK_RIGHT
		and event.pressed
	):
		var menu: RGmenu = RGmenu.new()
		menu.add_action("Select", Texture2D.new(), Sidebar.select_tab, [id], false)
		menu.add_seperator()
		menu.add_action("Unload", Icons.TRASH, PluginManager.unload_plugin, [id], true)
		RoseGarden.create_rc_menu(menu, get_global_mouse_position())
