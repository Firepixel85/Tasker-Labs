extends Node

var _client:Control

var doAnimation:bool = false
@warning_ignore("unused_signal")
signal tab_selected(new_tab:String)

func add_tab(title:String,icon:Texture2D,scene:Resource,tab_id:String):
	return _client._add_tab(title,icon,scene,tab_id)

func remove_tab(tab_id:String):
	return _client._remove_tab(tab_id)

func select_tab(selection_id:String):
	return _client.select(selection_id)

func get_selected_tab():
	return _client.selected

func _ready() -> void:
	await Settings.settings_loaded
	doAnimation = Settings.get_option_value("core.preferences/animate_sidebar")
	Settings.setting_changed.connect(_settings_changed)

func _settings_changed(option_path,new_value):
	if option_path == "core.preferences/animate_sidebar":
		doAnimation = new_value
