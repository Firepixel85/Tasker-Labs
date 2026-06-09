extends Control
class_name Command
@onready var button: Button = $Button
signal hovered(pos_y)
signal selected(pos_y)
signal execute

var manager:Control

func _on_mouse_entered() -> void:
	hovered.emit(position.y)


func _on_button_pressed() -> void:
	if manager.selection.position.y == position.y:
		execute.emit()
	else:
		selected.emit(position.y)
