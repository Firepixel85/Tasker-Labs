@tool
extends Control
class_name RGSegmentControl
@onready var texture: NinePatchRect = $NinePatchRect
@onready var text_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var button_container: HBoxContainer = $ButtonContainer
@onready var selector: NinePatchRect = $MarginContainer/Control/Selector
var items:Array = []
var items_text:Dictionary[String, String]
var refresh:bool = false
var selected:String
var _hovered:String = ""

func add_item(item_name:String,item_text:String) -> int:
	if _array_has_item(items,item_name):
		return Error.ERR_ALREADY_EXISTS
	items.append(item_name)

	text_container.add_child(Label.new())
	var target:Label = text_container.get_children()[text_container.get_children().size() - 1]
	target.text = "  "+item_text+"  "
	target.theme = load("res://Themes/Text/Secondary.tres")
	items_text[item_name] = item_text

	button_container.add_child(Button.new())
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(load("res://RG/Segment Control/RGsc_button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(target.size.x,60)
	target2._ready()
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
	items_text.erase(item_name)
	for child in button_container.get_children().size()-1:
		if button_container.get_child(child).item == item_name:
			button_container.get_child(child).queue_free()
			text_container.get_child(child).queue_free()
			break
	_update()
	_shade_options()
	return OK

func select(item:String):
	if !_array_has_item(items,item):
		return Error.ERR_DOES_NOT_EXIST

	selected = item
	var index = _find_index(items,item)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	var array = _build_size_array()
	var length := 0
	for i in index:
		length += array[i] + 8
	tween.tween_property(selector,"position",Vector2(length,selector.position.y),0.15*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
	tween.tween_property(selector,"size",Vector2(array[index],selector.size.y),0.15*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
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

func _update():
	var container_size = text_container.get_parent().size.x
	texture.size.x = container_size
	button_container.size.x = container_size
	custom_minimum_size.x = texture.size.x

func _delayed_update():
	await get_tree().create_timer(2).timeout
	var container_size = text_container.get_parent().size.x
	texture.size.x = container_size
	button_container.size.x = container_size

func _display_item(item_name:String,item_text:String) -> int:
	text_container.add_child(Label.new())
	var target:Label = text_container.get_children()[text_container.get_children().size() - 1]
	target.text = "  "+item_text+"  "
	target.theme = load("res://Themes/Text/Secondary.tres")
	items_text[item_name] = item_text

	button_container.add_child(Button.new())
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(load("res://RG/Segment Control/Button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(target.size.x,60)
	target2._ready()
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
		_display_item(item,items_text[item])

func _erase_items():
	for child in text_container.get_children():
		child.queue_free()
	for child in button_container.get_children():
		child.queue_free()

func _build_size_array():
	var array := []
	for child in text_container.get_children():
		array.append(child.size.x)
	return array

func _shade_options():
	for item in items:
		var target:Label = text_container.get_child(_find_index(items,item))
		if item == selected or item == _hovered:
			target.modulate = Color(1.0, 1.0, 1.0)
		else:
			target.modulate = Color(0.675, 0.675, 0.675)
