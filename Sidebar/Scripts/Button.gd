extends Button


@export var target_scale:float = 0.1
@export var child_path:NodePath
func _pressed() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(child_path),"scale",target_scale*0.8,0.1)
	tween.tween_property(get_node(child_path),"scale",target_scale,0.2)
