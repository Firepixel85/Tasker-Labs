extends HBoxContainer
@onready var about_button: RGButton = $"Sidebar/Sidebar Bottom/VBoxContainer/Control/AboutButton"
@onready var category_handler: Control = $"Sidebar/Sidebar Bottom/VBoxContainer/Categories"
@onready var main_view: Control = $".."

func setup():
	about_button._update()
	for id in Settings._category_list:
		category_handler._add_category(Settings.get_category_name(id),Settings.get_category_icon(id),id)


func _on_close_button_pressed() -> void:
	main_view.close_settings()
