@tool
extends "res://addons/RoseGarden/components/Container/RGContainer.gd"
@onready var margin_container: MarginContainer = $MarginContainer
@onready var root: Control = $"../../../../.."

func _ready() -> void:
	get_tree().root.size_changed.connect(_update_size)
	_update_size()

func _update_size():
	margin_container.position.x = 0
	await get_tree().process_frame
	custom_minimum_size.x = margin_container.get_minimum_size().x
	position.x = root.size.x-size.x-8
	_update()
	margin_container.position.x = 0
