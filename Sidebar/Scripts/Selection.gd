extends TextureRect

@onready var selection: Control = $".."

var tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = get_tree().create_tween()
func _process(delta: float) -> void:
	if rtv.settings["sidebar_selection"] == 1 or rtv.settings["sidebar_selection"] == 2:
		selection.visible = true
	else:
		selection.visible = false
func positionselection(pos):
	if rtv.settings["sidebar_selection"] == 1 or 2:
		tween = get_tree().create_tween()
		tween.tween_property(self,"position",Vector2(0,pos),0.1)
