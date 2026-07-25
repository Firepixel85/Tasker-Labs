extends Button

@export var color:String = "Red"
var selected:bool = false

signal selected_color(color:String)
func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)
	pressed.connect(_pressed)

func _mouse_entered():
	if selected:
		icon = load("res://Onboarding/Textures/Color/Selected/Color%s.svg" % color)
	else:
		icon = load("res://Onboarding/Textures/Color/Highlighted/Color%s.svg" % color)

func _mouse_exited():
	if selected:
		icon = load("res://Onboarding/Textures/Color/Selected/Color%s.svg" % color)
	else:
		icon = load("res://Onboarding/Textures/Color/Normal/Color%s.svg" % color)

func _pressed():
	selected = true
	selected_color.emit(color)
	icon = load("res://Onboarding/Textures/Color/Selected/Color%s.svg" % color)
