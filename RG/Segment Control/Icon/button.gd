extends Button
@onready var main: Control = get_parent().get_parent()

@export var item:String

func _pressed() -> void:
	print("select")
	get_parent().get_parent().select(item)
