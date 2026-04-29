extends Button

var id:String
var manager

func _pressed() -> void:
	manager._select(id)

func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)

func _mouse_entered():
	modulate = RoseGarden.Colors.TEXT_MAIN
	
func _mouse_exited():
	if !manager.selected == id:
		modulate = RoseGarden.Colors.TEXT_SECONDARY
