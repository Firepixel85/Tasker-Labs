extends Control
@onready var title_label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon_container: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var arrow: TextureRect = $MarginContainer/HBoxContainer2/TextureRect
@onready var button: Button = $Button

var title:String
var icon:Texture2D
var action:Callable
var action_params:Array
var menu:RGmenu
var is_menu:bool = false
var is_destructive = false
var is_submenu:bool = false
var manager:RGRighClickMenu

func update():
	title_label.text = title
	icon_container.texture = icon
	if is_menu:
		arrow.visible = true
		button.focus_mode = Control.FOCUS_NONE
	if is_destructive:
		title_label.modulate = Color("E74747")
		icon_container.modulate = Color("E74747")

func _on_button_mouse_entered() -> void:
	manager.selection.visible = true
	@warning_ignore("narrowing_conversion")
	manager.select_position(position.y,is_destructive)
	
	if is_submenu or manager.modulate == Color(1,1,1,0):
		return
		
	manager.update_selection(is_menu)
	if is_menu:
		RoseGarden._delete_submenu_instantly()
		RoseGarden._create_rc_submenu(menu,get_global_transform().origin-Vector2(9,8))

func _on_button_pressed() -> void:
	if is_menu:
		if RoseGarden.submenu != null:
			RoseGarden._delete_submenu_instantly()
		else:
			RoseGarden._create_rc_submenu(menu,get_global_transform().origin-Vector2(9,8))
		return
	if action_params == []:
		action.call()
	else:
		action.call(action_params)
	
func _on_button_mouse_exited() -> void:
	manager.selection.visible = false
