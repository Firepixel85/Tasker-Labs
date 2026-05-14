extends Control



func _on_get_plugins_pressed() -> void:
	Main.main_view.open_view("plugins")


func _on_learn_more_pressed() -> void:
	OS.shell_open("https://github.com/Rosepen-Studios")
