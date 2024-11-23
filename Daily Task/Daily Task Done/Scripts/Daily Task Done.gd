extends Control

var colorpointer:Dictionary = {0:"res://Daily Task/Textures/Colors/Big/Blue.png", 1:"res://Daily Task/Textures/Colors/Big/Green.png", 2:"res://Daily Task/Textures/Colors/Big/Orange.png", 3: "res://Daily Task/Textures/Colors/Big/Pink.png",4:"res://Daily Task/Textures/Colors/Big/Red.png",5:"res://Daily Task/Textures/Colors/Big/Teal.png"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg",5:"res://Daily Task/Textures/Icons/Big/Mindful.svg",6:"res://Daily Task/Textures/Icons/Big/Dollar.svg"}
@onready var taskname = $"Container/Task Left/MarginContainer/VBoxContainer/Name"
@onready var taskcolor = $"Container/Task Left/Color"
@onready var taskicon = $"Container/Task Left/Color/VBoxContainer/HBoxContainer/Icon"
@onready var taskstreak = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Count"
@onready var taskflame= $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Button"
@onready var animator: AnimationPlayer = $AnimationPlayer
var id:String
var deleted:bool
var decomplete
var is_tweening:bool = false
var wasdone
func _ready():
	if rtv.justcreatedid != -1:
		id = str(rtv.justcreatedid)

		taskname.text = rtv.namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		rtv.loadcreationstatus = 0
		rtv.iscreating = false
		animator.play("Added")
		update_streak_color()
		if rtv.donedic[id] == true:
			visible = true
		else:
			visible = false


func _process(_delta: float) -> void:
	if rtv.deletetarget == id and not deleted:
		deleted = true
		animator.play("Deleted")
		await animator.animation_finished
		visible= false

		
	if deleted == false:
		update_streak_color()
		taskname.text = rtv.namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		if animator.is_playing() == false:
			if rtv.donedic[id] == true:
				visible = true
			else:
				visible = false

func _on_edit_pressed() -> void:
	Input.action_press("Edit")
	Input.action_release("Edit")
	rtv.edittarget = id
	rtv.isediting = true
	print("(Daily Task "+str(id)+") INFO: Requested edit")

func _on_x_button_pressed() -> void:
	rtv.streakdic[id] -= 1 
	rtv.donedic[id] = false
	rtv.comlastlogdic[id] = false
	print("(Daily Task "+str(id)+") INFO: Decomplete")




func update_streak_color():
	#Defines streak flame color constants
	const STREAK_COLD = Color8(84, 157, 246)
	const STREAK_WARM = Color8(255, 159, 10)
	const STREAK_HOT = Color8(246, 94, 84)
	
	#Updates streak color
	if not deleted:
		var streak_value = rtv.streakdic[id]
		if streak_value <= 7:
			taskflame.modulate = STREAK_COLD
		elif streak_value <= 15:
			taskflame.modulate = STREAK_WARM
		else:
			taskflame.modulate = STREAK_HOT
