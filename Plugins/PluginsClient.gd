extends  Control

@onready var tabs: RGSegmentControl = $TopBar/HBoxContainer/MarginContainer/HBoxContainer/RGSegmentControl
@onready var main_view: Control = $".."

func _ready() -> void:
	tabs.add_item("explore","Explore")
	tabs.add_item("installed","Installed")

func _on_close_pressed() -> void:
	main_view.open_mainview()
