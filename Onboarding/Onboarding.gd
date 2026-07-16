extends Control
@onready var slide_container: HBoxContainer = $HBoxContainer
@onready var next: RGButton = $HBoxContainer/CenterContainer/RGContainer/VBoxContainer/MarginContainer2/HBoxContainer/Next
@onready var tou_next: RGButton = $HBoxContainer/TOU/RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Next

var slide:int = 0
func _ready() -> void:
	get_tree().root.size_changed.connect(_resize_slides)
	next.set_color("Tasker")
	
func _resize_slides():
	for child in slide_container.get_children():
		child.custom_minimum_size = size
	if slide >= 1:
		slide_container.position.x = -size.x
	else:
		slide_container.position.x = 0

func next_slide():
	RoseGarden.clear_tooltips()
	var tween = create_tween()
	if slide == 0:
		tween.tween_property(slide_container,"position:x",-size.x,0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	slide += 1

func _process(_delta: float) -> void:
	if !visible:
		return
	if Input.is_action_just_pressed("ui_confirm"):
		if slide == 0:
			tou_next.press()
		else:
			next.press()
