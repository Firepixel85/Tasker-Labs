extends TextureRect

@onready var animator: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	animator.play("Pulse")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_ready()

func stop():
	animator.stop()
	visible = false
