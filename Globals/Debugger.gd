extends Control
@onready var drop_down: DropDown = $"VBoxContainer/Content/Drop Down/Drop Down"

func _ready() -> void:
	print(drop_down.add_item("test",0))
	print(drop_down.add_item("op",1))
	print(drop_down.add_item("hipitihopityyyyyyyyyyy",2))


func _on_button_text_pressed() -> void:
	print(drop_down.remove_item(2))
