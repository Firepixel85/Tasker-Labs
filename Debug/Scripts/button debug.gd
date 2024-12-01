extends Button

func _pressed():
	print("Debug: Button Pressed")

func _process(delta: float) -> void:
	if is_hovered():
		print("Debug: Hovered")
	
