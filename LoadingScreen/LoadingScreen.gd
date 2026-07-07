extends Control


func _ready() -> void:
	get_window().size = Vector2(960, 540)
	while !Data._ready_to_load:
		pass
	await get_tree().create_timer(0.3).timeout
	if !Data.file_exists("Core/WindowData"):
		Data.make_file("WindowData", "Core")
		start_app(false)
	else:
		var window_data = Data.load_file("Core/WindowData")
		window_data["position"] = window_data["position"].split("(")[1].split(")")[0].split(",")
		window_data["size"] = window_data["size"].split("(")[1].split(")")[0].split(",")
		Main.window.size = Vector2(int(window_data["size"][0]), int(window_data["size"][1]))
		Main.window.position = Vector2(
			int(window_data["position"][0]), int(window_data["position"][1])
		)
		start_app(true)


func start_app(window_data_available: bool):
	RoseGarden.enable_custom_themes("res://CustomThemes")
	Settings.load_settings()  #Plugin scanning is done in settings loading since it needs to check if dev tools are enabled

	if window_data_available:
		get_window().size = Main.window.size
		get_window().position = Main.window.position
	else:
		get_window().size = Vector2(2272, 1516)
		center_window()

	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_RESIZE_DISABLED, false)
	Main.save_window_data()
	var mainview = preload("res://MainView/MainView.tscn")
	get_tree().change_scene_to_packed(mainview)


func center_window():
	var win_pos := get_window().position
	var win_size := get_window().size
	@warning_ignore("integer_division")
	var window_center := win_pos + win_size / 2
	var screen_index := 0
	for i in range(DisplayServer.get_screen_count()):
		var rect := DisplayServer.screen_get_usable_rect(i)
		if rect.has_point(window_center):
			screen_index = i
			break
	var screen_rect := DisplayServer.screen_get_usable_rect(screen_index)
	@warning_ignore("integer_division")
	var new_pos := screen_rect.position + (screen_rect.size - win_size) / 2
	get_window().position = new_pos
