extends Node

class window:
	static var size := Vector2(0,0)
	static var position := Vector2(0,0)

var version := "2.0"

func save_window_data():
	while true:
		window.size = get_window().size
		window.position = get_window().position
		Data.save_to("size",window.size,"window")
		Data.save_to("position",window.position,"window")
		Data.save_file("window")
		await get_tree().create_timer(1).timeout

func get_process_name(process_id:String):
	match process_id:
		"core.debug":
			return "Debug"
		"core.main":
			return "Main"
		"core.plugin_manager":
			return "PluginManager"
		"core.data":
			return "Data"
		"core.rose_garden":
			return "RoseGarden"
		"unknown":
			return "Unknown"
		_:
			return PluginManager.get_plugin_name(process_id)

func get_version():
	return version
