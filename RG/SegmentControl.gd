@tool
extends Control

@onready var texture: NinePatchRect = $NinePatchRect
@onready var text_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var button_container: HBoxContainer = $ButtonContainer
@onready var selector: NinePatchRect = $MarginContainer/Control/Selector
@export var items:Array = []
@export var items_text:Dictionary 
@export var refresh:bool = false
var selected:String

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
		_update()
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

func select(item:String):
	if !_array_has_item(items,item):
		return 404
	
	selected = item
	var index = _find_index(items,item)
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	var array = _build_size_array()
	var length := 0
	for i in index:
		length += array[i] + 4
	tween.tween_property(selector,"position",Vector2(length,selector.position.y),0.2).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(selector,"size",Vector2(array[index],selector.size.y),0.2).set_trans(Tween.TRANS_BOUNCE)
	_shade_options()
	
func add_item(item_name:String,item_text:String) -> int:
	if _array_has_item(items,item_name):
		return 400
	items.append(item_name)
	
	text_container.add_child(Label.new())
	var target:Label = text_container.get_children()[text_container.get_children().size() - 1]
	target.text = "  "+item_text+"  "
	target.add_theme_font_size_override("font_size",10)
	items_text[item_name] = item_text
	
	button_container.add_child(Button.new())
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(load("res://RG/Segment Control/Button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(target.size.x,30)
	_delayed_update()
	return 201
	
func display_item(item_name:String,item_text:String) -> int:
	text_container.add_child(Label.new())
	var target:Label = text_container.get_children()[text_container.get_children().size() - 1]
	target.text = "  "+item_text+"  "
	target.add_theme_font_size_override("font_size",10)
	items_text[item_name] = item_text
	
	button_container.add_child(Button.new())
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(load("res://RG/Segment Control/Button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(target.size.x,30)
	_delayed_update()
	return 201
	
	
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
		display_item(item,items_text[item])

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
		if item == selected:
			target.modulate = Color(1.0, 1.0, 1.0)
		else:
			target.modulate = Color(0.675, 0.675, 0.675)
