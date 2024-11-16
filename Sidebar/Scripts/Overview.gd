extends Button

@onready var animator: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if animator.is_playing() == false:
		if is_hovered():
			var tween = get_tree().create_tween()
			tween.tween_property($TextureRect,"scale",Vector2(0.12,0.12),0.1)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property($TextureRect,"scale",Vector2(0.1,0.1),0.1)

func _pressed() -> void:
	animator.play("Pressed")
