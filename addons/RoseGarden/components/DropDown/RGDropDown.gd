@tool
extends Control
class_name RGDropDown
@onready var label: Label = $NinePatchRect/MarginContainer/HBoxContainer/Label
@onready var container: NinePatchRect = $NinePatchRect
@onready var menu_container: NinePatchRect = $CanvasLayer/NinePatchRect2
@onready var menu_item_container: VBoxContainer = $CanvasLayer/NinePatchRect2/MarginContainer/VBoxContainer
@onready var button: Button = $Button
@onready var selection: NinePatchRect = $CanvasLayer/NinePatchRect2/SelectionContainer/Container/Selection
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var arrow: TextureRect = $NinePatchRect/MarginContainer/HBoxContainer2/VBoxContainer/TextureRect

var items:Array = []
var item_ids:Array = []
var last_given_id:int = -1
var selected:int = 0
var _is_open:bool = false
var _hovered:bool = false
var canvas_layer_index:int = 0:
	set(new_value):
		canvas_layer_index = new_value
		canvas_layer.layer = new_value
signal new_selection(selection:String)
signal opened
signal closed

func add_item(item_name:String,item_id:int):
	if _array_has_item(item_ids,item_id):
		return Error.ERR_ALREADY_EXISTS
	items.append(item_name)
	item_ids.append(item_id)
	menu_item_container.add_child(preload("res://addons/RoseGarden/components/DropDown/Menu Item/RGmenu_item.tscn").instantiate())
	var target:Control = menu_item_container.get_children()[menu_item_container.get_children().size() - 1]
	target.manager = self
	target.id = item_id
	target.option_name = item_name
	target._ready()
	_update()
	menu_container.modulate = Color(1,1,1,0)
	open()
	close(true)
	menu_container.modulate = Color(1,1,1,1)
	return OK

func remove_item(item_id:int):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	items.remove_at(_find_index(item_ids,item_id))
	item_ids.remove_at(_find_index(item_ids,item_id))
	for child in menu_item_container.get_children():
		if child.id == item_id:
			child.queue_free()
	_update()
	selection.position.y = 0
	return OK

func select(item_id:int):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	selected = item_id
	new_selection.emit(items[_find_index(item_ids,item_id)])
	_update()
	return OK

func rename_item(item_id:int,new_name:String):
	if !_array_has_item(item_ids,item_id):
		return Error.ERR_DOES_NOT_EXIST
	items[_find_index(item_ids,item_id)] = new_name
	for child in menu_item_container.get_children():
		if child.id == item_id:
			child.option_name = new_name
			child._update()
	_update()
	return OK

func get_selected():
	return selected

func get_selected_item():
	return items[_find_index(item_ids,selected)]

func is_open():
	return _is_open

var selected_when_opened:int = 0
func open():
	if _is_open:
		return
	selected_when_opened = selected
	_is_open = true
	grab_focus()
	menu_container.position = global_position
	for child in menu_item_container.get_children():
		if child.id == selected:
			child.selected = true
		if child.id == selected and !_hovered:
			child.highlighted = true
		if child.id == item_ids[0] and _hovered:
			child.highlighted = true
		child._update()
	if _hovered:
		create_tween().tween_property(selection,"position:y",0,0.01*int(!RoseGarden.Accessibility.get_disable_animations())*int(RoseGarden.Animations.ddmSelection)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	else:
		_on_menu_item_highlighted(selected)
	_update()
	menu_container.visible=true
	selection.visible = true
	opened.emit()

func close(invisible:bool=false):
	_is_open = false
	var tween = create_tween()
	selection.hide()
	tween.tween_property(menu_container,"size",size,0.07*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.07*int(!invisible)).timeout
	menu_container.hide()
	closed.emit()

##############
#### STOP #### Here begin private functions that should never be called by your code
##############



func _ready() -> void:
	RoseGarden.custom_textures_changed.connect(_update)
	RoseGarden.custom_themes_changed.connect(_update_themes)
	_update_themes()
	_update()

func _update():
	if !Engine.is_editor_hint():
		if size_flags_horizontal != SIZE_EXPAND_FILL:
			size.x = menu_item_container._get_min_size() + 16
		else:
			custom_minimum_size.x = 0
		if !_array_has_item(item_ids,selected) and item_ids !=[]:
			selected = item_ids[0]

	container.texture = load(RoseGarden._file_path+"DropDown/Container.svg")
	arrow.texture = load(RoseGarden._file_path+"DropDown/Arrow.svg")
	menu_container.texture = load(RoseGarden._file_path+"DropDown/Container.svg")
	selection.texture = load(RoseGarden._file_path+"DropDown/Selection.svg")
	selection.custom_minimum_size.x = menu_container.size.x-12
	container.size = size
	menu_container.size = size
	custom_minimum_size = size
	menu_container.custom_minimum_size.x = size.x
	create_tween().tween_property(menu_container,"size",Vector2(size.x,(menu_item_container.get_child_count()*52)+12),0.07*int(!RoseGarden.Accessibility.get_disable_animations())*int(RoseGarden.Animations.ddmAppearance)).set_trans(Tween.TRANS_SINE)
	button.custom_minimum_size = size
	if !items.size()==0:
		label.text = items[_find_index(item_ids,selected)]
	else:
		label.text = ""

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


func _pressed() -> void:
	open()

func _new_menu_item(node: Node) -> void:
	await node._updated
	_update()

func _on_menu_item_highlighted(id: int) -> void:
	selection.visible = true
	create_tween().tween_property(selection,"position",Vector2(selection.position.x,52*_find_index(item_ids,id)),0.07*int(!RoseGarden.Accessibility.get_disable_animations())*int(RoseGarden.Animations.ddmSelection)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _select_item(id: int):
	selection.visible = true
	create_tween().tween_property(selection,"position",Vector2(selection.position.x,52*_find_index(item_ids,id)),0.07*int(!RoseGarden.Accessibility.get_disable_animations())*int(RoseGarden.Animations.ddmSelection)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	selected = id
	for item in menu_item_container.get_children():
		if item.id == id:
			item.highlighted = true
		else:
			item.highlighted = false
		item._update()

func _on_focus_exited() -> void:
	await get_tree().process_frame
	for child in menu_item_container.get_children():
		if child.button.has_focus():
			return
	if !has_focus():
		close()

func _on_mouse_entered() -> void:
	_hovered = true
	modulate = RoseGarden.Colors.COLOR_HOVERED


func _on_mouse_exited() -> void:
	_hovered = false
	modulate = RoseGarden.Colors.COLOR_NORMAL


func _on_button_up() -> void:
	modulate = RoseGarden.Colors.COLOR_HOVERED


func _on_button_down() -> void:
	modulate = RoseGarden.Colors.COLOR_PRESSED

func _update_themes():
	label.theme = RoseGarden.Themes.Secondary

func _process(delta: float) -> void:
	if !_is_open:
		return
	menu_container.position = global_position

func _input(event: InputEvent) -> void:
	if !_is_open or !(event is InputEventKey) or event.pressed:
		return
	if event.keycode == KEY_UP and _find_index(item_ids,get_selected()) > 0:
		_select_item(item_ids[_find_index(item_ids,get_selected())-1])
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_DOWN and _find_index(item_ids,get_selected()) < item_ids.size()-1:
		_select_item(item_ids[_find_index(item_ids,get_selected())+1])
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ENTER:
		await get_tree().process_frame
		close()
		label.text = items[_find_index(item_ids,selected)]
		get_viewport().set_input_as_handled()
	elif event.keycode == KEY_ESCAPE:
		_select_item(selected_when_opened)
		await get_tree().process_frame
		close()
		label.text = items[_find_index(item_ids,selected)]
		get_viewport().set_input_as_handled()
