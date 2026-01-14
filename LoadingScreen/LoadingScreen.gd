extends Control

func _ready() -> void:
	get_window().size = Vector2(480*2,270*2)
	center_window()
	#await get_tree().create_timer(1).timeout
	if !Data.file_exists("window"):
		Data.make_file("window")
		start_app(false)
	else:
		var window_data = Data.load_file("window")
		window_data["position"] = window_data["position"].split("(")[1].split(")")[0].split(",")
		window_data["size"] = window_data["size"].split("(")[1].split(")")[0].split(",")
		Main.window.size = Vector2(int(window_data["size"][0]),int(window_data["size"][1]))
		Main.window.position = Vector2(int(window_data["position"][0]),int(window_data["position"][1]))
		start_app(true)

func start_app(window_data_available:bool):
	if window_data_available:
		get_window().size = Main.window.size
		get_window().position = Main.window.position
	else:
		get_window().size = Vector2(1300,731)
		center_window()

	get_tree().change_scene_to_file("res://test.tscn")
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)

	Main.save_window_data()

func center_window():
	var win_pos := get_window().position
	var win_size := get_window().size
	var window_center := win_pos + win_size / 2
	var screen_index := 0
	for i in range(DisplayServer.get_screen_count()):
		var rect := DisplayServer.screen_get_usable_rect(i)
		if rect.has_point(window_center):
			screen_index = i
			break
	var screen_rect := DisplayServer.screen_get_usable_rect(screen_index)
	var new_pos := screen_rect.position + (screen_rect.size - win_size) / 2
	get_window().position = new_pos
		
