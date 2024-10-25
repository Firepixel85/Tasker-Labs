extends TextureRect

var tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = get_tree().create_tween()
	
func positionselection(pos):
	tween = get_tree().create_tween()
	tween.tween_property(self,"position",Vector2(0,pos),0.1)
