extends Button

func _pressed():
	if rtv.iscreating == false:
		Input.action_press("Add")
		Input.action_release("Add")
		button_pressed = false

func _process(delta: float) -> void:
	if is_hovered():
		pass
	
