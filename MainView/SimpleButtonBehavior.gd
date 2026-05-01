extends Button

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	modulate = RoseGarden.Colors.TEXT_MAIN

func _mouse_exited():
	modulate = RoseGarden.Colors.TEXT_SECONDARY
