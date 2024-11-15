extends Label
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

func set_warn(warn:String):
	text = warn
	animator.play("In")
	timer.start()
	await  timer.timeout
	clear_warn()

func clear_warn():
	animator.play("Out")
