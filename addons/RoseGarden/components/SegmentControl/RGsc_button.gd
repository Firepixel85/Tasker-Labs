extends Button
@onready var main: Control = get_parent().get_parent()

@export var item:String

func _pressed() -> void:
	get_parent().get_parent().get_parent().get_parent().select(item)

func _mouse_entered() -> void:
	get_parent().get_parent().get_parent().get_parent()._hovered = item
	get_parent().get_parent().get_parent().get_parent()._shade_options()

func _mouse_exited() -> void:
	get_parent().get_parent().get_parent().get_parent()._hovered = ""
	get_parent().get_parent().get_parent().get_parent()._shade_options()

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
