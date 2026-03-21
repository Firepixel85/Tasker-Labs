@tool
extends Control
class_name RGSegmentControlIcon
@onready var texture: NinePatchRect = $NinePatchRect
@onready var icon_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var button_container: HBoxContainer = $ButtonContainer
@onready var selector: TextureRect = $MarginContainer/Control/Selector
var refresh:bool = false
var items:Array = []
var item_icons:Dictionary[String, Texture2D]
var selected:String

func select(item_name:String):
	if !_array_has_item(items,item_name):
		return ERR_DOES_NOT_EXIST
	
	selected = item_name
	var index = _find_index(items,item_name)
	get_tree().create_tween().tween_property(selector,"position",Vector2(56*index,selector.position.y),0.15).set_trans(Tween.TRANS_SINE)
	_shade_options()
	return OK

func add_item(item_name:String,item_icon:Texture2D) -> int:
	if _array_has_item(items,item_name):
		return ERR_ALREADY_EXISTS
	items.append(item_name)
	
	icon_container.add_child(TextureRect.new())
	var target:TextureRect = icon_container.get_children()[icon_container.get_children().size() - 1]
	target.texture = item_icon
	item_icons[item_name] = item_icon
	
	button_container.add_child(Button.new())
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(preload("res://RG/Segment Control/RGsc_button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(60,60)
	if selected == "":
		select(item_name)
	_update()
	_shade_options()
	return OK
	
func remove_item(item_name:String):
	if !_array_has_item(items,item_name):
		return ERR_DOES_NOT_EXIST
	if selected == item_name:
		return ERR_LOCKED
		
	items.remove_at(_find_index(items,item_name))
	item_icons.erase(item_name)
	for child in button_container.get_children().size()-1:
		if button_container.get_child(child).item == item_name:
			button_container.get_child(child).queue_free()
			icon_container.get_child(child).queue_free()
			break
	_update()
	_shade_options()
	return OK

##############
#### STOP #### Here begin private function that should never be called by your code
##############

func _process(_delta: float) -> void:
	if refresh:
		refresh = false
		_erase_items()
		_load_items()
		select(items[0])
	_update()

func _ready() -> void:
	if !Engine.is_editor_hint():
		_load_items()
		if !items == []:
			select(items[0])
		_update()

func _update():
	var container_size = icon_container.get_parent().size.x
	texture.size.x = container_size
	button_container.size.x = container_size
	custom_minimum_size.x = texture.size.x

func _delayed_update():
	await get_tree().create_timer(2).timeout
	var container_size = icon_container.get_parent().size.x
	texture.size.x = container_size
	button_container.size.x = container_size

	
func _display_item(item_name:String,item_icon:Texture2D) -> int:
	icon_container.add_child(TextureRect.new())
	var target:TextureRect = icon_container.get_children()[icon_container.get_children().size() - 1]
	target.texture = item_icon
	item_icons[item_name] = item_icon
	
	button_container.add_child(Button.new())
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(load("res://RG/Segment Control/Button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(60,60)
	_delayed_update()
	return OK
	
	
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


func _load_items():
	for item in items:
		_display_item(item,item_icons[item])

func _erase_items():
	for child in icon_container.get_children():
		child.queue_free()
	for child in button_container.get_children():
		child.queue_free()
		
func _shade_options():
	for item in items:
		var target:TextureRect = icon_container.get_child(_find_index(items,item))
		if item == selected:
			target.modulate = Color(1.0, 1.0, 1.0)
		else:
			target.modulate = Color(0.675, 0.675, 0.675)
