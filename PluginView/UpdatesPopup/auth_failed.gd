extends Control


func _on_close_pressed() -> void:
	Popups.remove_popup()


func _on_retry_pressed() -> void:
	Popups.remove_popup()
	await Popups.popup_removed
	Popups.add_popup(load("res://PluginView/UpdatesPopup/GitHubAuth.tscn"))
