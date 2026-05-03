extends Button

@onready var parent: Control = $"../../.."
@export var color:String = "Pink"

var highlighted = false
var selected = false
func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	
func _mouse_entered():
	highlighted = true
	_update()

func _mouse_exited():
	highlighted = false
	_update()

func _pressed() -> void:
	parent.set_value(color)
	parent._on_selected(color)
	_update()

func select(select_color:String):
	if color == select_color:
		selected = true
	else:
		selected = false
	_update()

func _update():
	var texture_path = "res://Settings/CoreOptions/Appearance/AccentColor/"
	if selected:
		texture_path += "Selected/"
	elif highlighted:
		texture_path += "Highlighted/"
	else:
		texture_path += "Normal/"
	texture_path += color+".svg"
	icon = load(texture_path)
