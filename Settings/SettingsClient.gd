extends HBoxContainer
@onready var about_button: RGButton = $"Sidebar/Sidebar Bottom/VBoxContainer/Control/AboutButton"
@onready var category_handler: Control = $"Sidebar/Sidebar Bottom/VBoxContainer/Categories"
@onready var option_handler: VBoxContainer = $VBoxContainer2/SceneContainer/MarginContainer/OptionHandler

@onready var main_view: Control = $".."

func setup():
	about_button._update()
	for id in Settings._category_list:
		category_handler._add_category(Settings.get_category_name(id),Settings.get_category_icon(id),id)
	category_handler._select(Settings._category_list[0])


func _on_close_button_pressed() -> void:
	main_view.close_settings()


func _on_category_selected(category_id: Variant) -> void:
	for child in option_handler.get_children():
		child.queue_free()
	for option in Settings.get_category(category_id):
		var option_node = option_handler.add_option(option,load(Settings.get_category(category_id)[option]))
		option_node.set_value(Settings.get_option_value(category_id+"/"+option))
		option_node.name = option
		option_node.value_changed.connect(setting_changed)

func setting_changed(option_id:String,new_value):
	Settings.set_option_value(category_handler.selected+"/"+option_id,new_value)
