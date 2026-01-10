extends Control


var moving
var mouse_start:Vector2i



func _ready() -> void:
	gui_input.connect(move_window)

		
func _process(_delta: float) -> void:
	if moving:
		var mouse_delta:= Vector2i(get_viewport().get_mouse_position()) - mouse_start
		get_window().position += mouse_delta


func move_window(event:InputEvent):
	if event is InputEventMouseButton and event.button_index == 1:
		if !moving:
			mouse_start = get_viewport().get_mouse_position()
		moving = event.is_pressed()
