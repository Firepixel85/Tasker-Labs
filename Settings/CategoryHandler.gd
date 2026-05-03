extends Control
@onready var category_container: VBoxContainer = $CategoryButtons/ScrollContainer/VBoxContainer
@onready var selection: NinePatchRect = $Selection

var categories = []
var selected:String

signal category_selected(category_id)

func _add_category(title:String,icon:Texture2D,category_id:String):
	if categories.has(category_id):
		return ERR_ALREADY_EXISTS
	categories.append(category_id)
	category_container.add_child(Button.new())
	var category:Button = category_container.get_child(category_container.get_child_count()-1)
	category.set_script(preload("res://Sidebar/TabButton.gd"))
	category.text = title
	category.icon = icon
	category.flat = true
	category.alignment = HORIZONTAL_ALIGNMENT_LEFT
	category.theme = preload("res://CustomThemes/Main.tres")
	category.add_theme_stylebox_override("Focus",StyleBoxEmpty.new())
	category.manager = self
	category.id = category_id
	category._ready()
	if selected == "":
		selected = categories[0]
		#Display options logic placeholder
	_shade_categories()
	return OK


func _remove_tab(category_id:String):
	if !categories.has(category_id):
		return ERR_DOES_NOT_EXIST
	for child in category_container.get_children():
		if child.id == category_id:
			child.queue_free()
			categories.remove_at(_find_index(categories,category_id))
			if selected == category_id:
				selected = categories[0]
			_shade_categories()
			break
	return OK

func _find_index(array:Array,item):
	var index = 0
	for i in array.size():
		if array[i] == item:
			index = i
	return index

func _select(selection_id:String):
	if !categories.has(selection_id):
		return ERR_DOES_NOT_EXIST
	selected = selection_id
	selection.visible = true
	create_tween().tween_property(selection,"position",Vector2(0,80*_find_index(categories,selection_id)),0.15*int(Sidebar.doAnimation)*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	_shade_categories()
	category_selected.emit(selection_id)
	#Display options logic placeholder
	Sidebar.tab_selected.emit(selection_id)
	return OK

func _shade_categories():
	for child in category_container.get_children():
		if child.id == selected:
			child.modulate = RoseGarden.Colors.TEXT_MAIN
		else:
			child.modulate = RoseGarden.Colors.TEXT_SECONDARY
