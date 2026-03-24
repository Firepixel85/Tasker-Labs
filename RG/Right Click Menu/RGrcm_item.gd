extends Control
@onready var title_label: Label = $MarginContainer/HBoxContainer/Label
@onready var icon_container: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var arrow: TextureRect = $MarginContainer/HBoxContainer2/TextureRect

var title:String
var icon:Texture2D
var action:Callable
var action_params:Array
var is_menu:bool = false
var is_destructive = false
var manager:RGRighClickMenu
func update():
	title_label.text = title
	icon_container.texture = icon
	if is_menu:
		arrow.visible = true
	if is_destructive:
		title_label.modulate = Color("E74747")
		icon_container.modulate = Color("E74747")



func _on_button_mouse_entered() -> void:
	@warning_ignore("narrowing_conversion")
	manager.select_position(position.y,is_destructive)


func _on_button_pressed() -> void:
	if action_params == []:
		action.call()
	else:
		action.call(action_params)
