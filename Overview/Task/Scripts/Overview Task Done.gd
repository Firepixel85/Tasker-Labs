extends Control

@onready var taskname: Label = $TextureRect/MarginContainer/HBoxContainer/Label
@onready var streak: Label = $TextureRect/MarginContainer/HBoxContainer2/Label
var id:String
var deleted:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = str(rtv.justcreatedid_overview)
	rtv.loadcreationstatus_overview = 1
	taskname.text = rtv.namedic[id]
	streak.text = str(rtv.streakdic[id])
	
func _process(_delta: float) -> void:
	if rtv.deletetarget == id:
		deleted = true
		visible = false
	if deleted == false:
		streak.text = str(rtv.streakdic[id])
		update_streak_color()
		if rtv.donedic[id] == true:
			visible = true
		else:
			visible = false

func update_streak_color(): 
	if deleted == false:
		if rtv.streakdic[id] <= 7:
			streak.modulate = Color8(84,157,246)
		elif rtv.streakdic[id] > 7 and rtv.streakdic[id] <= 15:
			streak.modulate = Color8(255,159,10)
		elif rtv.streakdic[id] > 15 :
			streak.modulate = Color8(246,94,84)
