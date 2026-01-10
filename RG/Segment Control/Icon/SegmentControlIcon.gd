@tool
extends Control

@onready var texture: NinePatchRect = $NinePatchRect
@onready var icon_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var button_container: HBoxContainer = $ButtonContainer
@onready var selector: TextureRect = $MarginContainer/Control/Selector
@export var items:Array = []
var item_icons:Dictionary 
var selected:String

func _process(delta: float) -> void:
	_update()

func _ready() -> void:
	_update()
	add_item("focus","res://Icons/Book.svg")
	add_item("home","res://Icons/Home.svg")
	add_item("tasks","res://Icons/Checklist.svg")

	
	
func _update():
	var container_size = icon_container.get_parent().size.x
	var other = icon_container.get_parent()
	#print(container_size)
	texture.size.x = container_size
	button_container.size.x = container_size

func _delayed_update():
	await get_tree().create_timer(2).timeout
	var container_size = icon_container.get_parent().size.x
	texture.size.x = container_size
	button_container.size.x = container_size

func select(item:String):
	if !_array_has_item(items,item):
		return 404
	
	selected = item
	items.sort()
	var index = items.bsearch(item) 
	get_tree().create_tween().tween_property(selector,"position",Vector2(28*index,selector.position.y),0.2).set_trans(Tween.TRANS_BOUNCE)
		
func add_item(item_name:String,item_icon:String) -> int:
	items.sort()
	if _array_has_item(items,item_name):
		print("aborted")
		return 400
	items.append(item_name)
	
	icon_container.add_child(TextureRect.new())
	#await icon_container.child_entered_tree
	var target:TextureRect = icon_container.get_children()[icon_container.get_children().size() - 1]
	target.set_script(load("res://Globals/svgHelpers/svgHelperTextureRect.gd"))
	target.SVGPath = item_icon
	target.texture = load(item_icon)
	item_icons[item_name] = item_icon
	
	
	button_container.add_child(Button.new())
	#await button_container.child_entered_tree
	var target2:Button = button_container.get_children()[button_container.get_children().size() - 1]
	target2.set_script(load("res://RG/Segment Control/Icon/button.gd"))
	target2.flat = true
	target2.add_theme_stylebox_override("focus",StyleBoxEmpty.new())
	target2.item = item_name
	target2.custom_minimum_size = Vector2(30,30)
	_delayed_update()
	return 201
	
	
func _array_has_item(array:Array,item):
	var found := false
	for part in array:
		if part == item:
			found = true
			break
	return found


	
