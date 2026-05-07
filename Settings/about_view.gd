extends Control

@onready var letter: TextureRect = $TextureRect

func _ready() -> void:
	print(size)
	letter.position = Vector2(0,0)
