extends Button
@onready var animator: AnimationPlayer = $AnimationPlayer

func _pressed():
	if rtv.iscreating == false:
		animator.play("Pressed")
		Input.action_press("Add")
		Input.action_release("Add")
		button_pressed = false
	else:
		animator.play("No")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Add") and rtv.iscreating == false:
		animator.play("Pressed")
	if animator.is_playing() == false:
		if is_hovered():
			var tween = get_tree().create_tween()
			tween.tween_property($TextureRect,"scale",Vector2(0.12,0.12),0.1)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property($TextureRect,"scale",Vector2(0.1,0.1),0.1)
