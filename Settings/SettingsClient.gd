extends HBoxContainer

@onready var category_handler: Control = $"Sidebar/Sidebar Bottom/VBoxContainer/Categories"
@onready var option_handler: VBoxContainer = $VBoxContainer2/SceneContainer/MarginContainer/OptionHandler

@onready var main_view: Control = $".."

var _opened_category = ""

func _ready() -> void:
	Settings._client = self
func setup():
	for id in Settings._category_list:
		category_handler._add_category(Settings.get_category_name(id),Settings.get_category_icon(id),id)
	if _opened_category == "":
		category_handler._select(Settings._category_list[0])
	category_handler._select(_opened_category)

func _on_close_button_pressed() -> void:
	main_view.open_view("mainview")


func _on_category_selected(category_id: String) -> void:
	if category_id == _opened_category:
		return
	_opened_category = category_id
	_reset_opened_category()
	for child in option_handler.get_children():
		child.queue_free()
	await get_tree().process_frame
	for option in Settings._option_order[category_id]:
		var option_node = option_handler.add_option(option,load(Settings.get_category(category_id)[option]))
		option_node.set_value(Settings.get_option_value(category_id+"/"+option))
		option_node.name = option
		option_node.value_changed.connect(setting_changed)

func setting_changed(option_id:String,new_value):
	Settings.set_option_value(category_handler.selected+"/"+option_id,new_value)


func _on_about_button_pressed() -> void:
	category_handler.selected = ""
	category_handler.selection.visible = false
	category_handler._shade_categories()
	for child in option_handler.get_children():
		child.queue_free()
	await get_tree().process_frame
	option_handler.add_child(preload("res://Settings/AboutView.tscn").instantiate())

func _reset_opened_category():
	await get_tree().create_timer(90).timeout
	_opened_category = ""
