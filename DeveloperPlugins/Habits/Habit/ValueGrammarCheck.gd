@tool
extends RGText

func _ready():
	if Engine.is_editor_hint():
		return
	while true:
		if get_parent().get_child(2).get_text() == "1":
			set_text("day")
		else:
			set_text("days")
		await get_tree().create_timer(0.1).timeout
