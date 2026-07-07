extends Control


func _on_get_plugins_pressed() -> void:
	Input.action_press("plugin_open")
	Input.action_release("plugin_open")


func _on_learn_more_pressed() -> void:
	OS.shell_open("https://github.com/Rosepen-Studios")
