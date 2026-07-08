extends Control


func _on_button_pressed() -> void:
	Network.Updates.update()
