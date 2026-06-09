extends Control


func _on_rg_button_pressed() -> void:
	Input.action_press("view_close")
	Input.action_release("view_close")
	OS.shell_open("https://github.com/Firepixel85/Tasker-Labs/blob/main/DeveloperPluginGuide.md")
