extends Control
class_name RGRighClickMenu

func _ready() -> void:
	grab_focus()

func _on_focus_exited() -> void:
	visible = false
	await get_tree().create_timer(0.1).timeout
	queue_free()
