extends VBoxContainer

@onready var greeting: Label = $MarginContainer/HBoxContainer/Label

func _ready() -> void:
	greeting.text = "Welcome back "+rtv.settings["username"]+"!"

func _process(delta: float) -> void:
	if rtv.settings["username"] == "":
		visible = false
	else:
		visible = true
		greeting.text = "Welcome back "+rtv.settings["username"]+"!"
