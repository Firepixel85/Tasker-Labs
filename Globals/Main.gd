extends Node

class window:
	static var size := Vector2(0,0)
	static var position := Vector2(0,0)
	

func save_window_data():
	while true:
		window.size = get_window().size
		window.position = get_window().position
		Data.save_to("size",window.size,"window")
		Data.save_to("position",window.position,"window")
		Data.save_file("window")
		await get_tree().create_timer(1).timeout
