extends Control


func _on_rich_text_label_meta_clicked(_meta: Variant) -> void:
	await Popups.remove_popup()
	Popups.add_popup(load("res://PluginView/UpdatesPopup/GitHubAuth.tscn"))
