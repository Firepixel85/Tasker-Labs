extends VBoxContainer

@onready var time_label = $"MarginContainer/HBoxContainer/Time Label"
var time
var showseconds:bool = false

func _process(delta):
	time = Time.get_time_string_from_system().split(":")
	if showseconds == true:
		time_label.text = (time[0]+":"+time[1]+":"+time[2])
	else:
		time_label.text = (time[0]+":"+time[1])
	if Input.is_action_pressed("Exit"):
		get_tree().quit()
