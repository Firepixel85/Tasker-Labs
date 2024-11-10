extends VBoxContainer

@onready var greeting: Label = $MarginContainer/HBoxContainer/Label

func _ready() -> void:
	greeting.text = "Welcome back "+rtv.settings["username"]+"!"

func _on_orientationcomp() -> void:
	greeting.text = "Welcome back "+rtv.settings["username"]+"!"

func _process(delta: float) -> void:
	greeting.text = "Welcome back "+rtv.settings["username"]+"!"
