extends Node

var main_view:Control

class window:
	static var size := Vector2(0,0)
	static var position := Vector2(0,0)

const version:String = "2.0"
const version_sufix:String = "pb1"
const plugin_api_version:String = "1.0"

func save_window_data():
	while true:
		window.size = get_window().size
		window.position = get_window().position
		Data.save_to("size",window.size,"WindowData")
		Data.save_to("position",window.position,"WindowData")
		Data.save_file("WindowData",true)
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
		"core.sidebar":
			return "Sidebar"
		"core.settings":
			return "Settings"
		"core.popups":
			return "Popups"
		"core.main_view":
			return "MainView"
		"core.icons":
			return "Icons"
		"unknown":
			return "Unknown"
		_:
			if int(PluginManager.get_plugin_name(process_id)) == int(ERR_DOES_NOT_EXIST):
				return "Unknown"
			else:
				return PluginManager.get_plugin_name(process_id)

func get_version():
	return version

func get_version_sufix():
	return version_sufix

func get_plugin_api_version():
	return plugin_api_version

func get_current_view():
	return main_view._current_view

func get_view_node():
	return main_view.view_nodes[main_view._current_view]
