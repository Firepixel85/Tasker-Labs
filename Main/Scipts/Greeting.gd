extends VBoxContainer

@onready var greeting: Label = $MarginContainer/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	greeting.text = "Welcome back "+rtv.username+"!"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
