extends Control
@onready var drop_down: DropDown = $"MarginContainer/VBoxContainer/Content/Drop Down/Drop Down"

func _ready() -> void:
	drop_down.add_item("Option 1",0)
	drop_down.add_item("Option 2",1)
	drop_down.add_item("Option 3",2)
