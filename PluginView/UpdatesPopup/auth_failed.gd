extends Control


func _on_close_pressed() -> void:
	Popups.clear_popup()


func _on_retry_pressed() -> void:
	Popups.clear_popup()
	await Popups.popup_cleared
	Popups.add_popup(load("res://PluginView/UpdatesPopup/GitHubAuth.tscn"))
