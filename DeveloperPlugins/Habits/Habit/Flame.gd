extends AnimatedSprite2D

signal transitioned
func trans_to(new_anim:String):
	if is_playing():
		await animation_looped
	play(new_anim)
	transitioned.emit()
