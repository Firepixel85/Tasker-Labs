extends Control

var colorpointer:Dictionary = {0:"res://Daily Task/Textures/Colors/Big/Blue.png", 1:"res://Daily Task/Textures/Colors/Big/Green.png", 2:"res://Daily Task/Textures/Colors/Big/Orange.png", 3: "res://Daily Task/Textures/Colors/Big/Pink.png",4:"res://Daily Task/Textures/Colors/Big/Red.png",5:"res://Daily Task/Textures/Colors/Big/Teal.png"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg",5:"res://Daily Task/Textures/Icons/Big/Mindful.svg",6:"res://Daily Task/Textures/Icons/Big/Dollar.svg"}

@onready var task: TextureRect = $Container

@onready var taskname = $"Container/Task Left/MarginContainer/VBoxContainer/Name"
@onready var taskcolor = $"Container/Task Left/Color"
@onready var taskicon = $"Container/Task Left/Color/VBoxContainer/HBoxContainer/Icon"
@onready var taskstreak = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Count"
@onready var taskflame = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Button"
@onready var animator: AnimationPlayer = $AnimationPlayer

@onready var done: Button = $"Container/Task Right/Buttons/Buttons/Done Container/Done"
@onready var edit: Button = $"Container/Task Right/Buttons/Buttons/Edit Container/Edit"

var id:String
var deleted:bool
var complete
var is_tweening:bool = false
var wasdone:bool
func _ready():
	if rtv.justcreatedid != -1:
		id = str(rtv.justcreatedid)
		rtv.justcreatedid = -1
		
		#Calculates streak status based on lastlog data
		if rtv.streakstatus == "hold" and rtv.comlastlogdic[id] == false:
			rtv.streakdic[id] = 0
		elif rtv.streakstatus == "kill":
			rtv.streakdic[id] = 0
			rtv.comlastlogdic[id] = false
			rtv.donedic[id] = false
		if rtv.streakstatus == "hold":
			rtv.donedic[id] = false
			rtv.comlastlogdic[id] = false
		#Sets task data from rtv dictionaries and restes local variables
		taskname.text = rtv. namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		rtv.loadcreationstatus = 0
		rtv.iscreating = false
		
		#Playes the "Added" animation when the task is done loading
		animator.play("Added")
		update_streak_color()
		if is_tweening == false:
			if rtv.donedic[id] == false:
				visible = true
			else:
				visible = false
			
		print("(Daily Task "+str(id)+") INFO: Data loaded")
	else:
		print("(Daily Task "+str(id)+") ERROR: Task ID is invalid")
	
func _process(_delta: float) -> void:
	
	#Deletes task
	if rtv.deletetarget == id and not deleted:
		deleted = true
		animator.play("Deleted")
		await animator.animation_finished
		visible = false
		print("(Daily Task "+str(id)+") INFO: Deleting")

	if deleted == false:
		update_streak_color()
		
		#Updates task info
		taskname.text = rtv.namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		
		#Updates task visibility
		if animator.is_playing() == false:
			if rtv.donedic[id] == false:
				visible = true
			else:
				visible = false
		
		#Corrects incorrect streak values
		if rtv.streakdic[id] < 0: 
			rtv.streakdic[id] = 0


func _on_done_pressed() -> void: #Completes the task
	rtv.streakdic[id] += 1
	rtv.donedic[id] = true
	rtv.comlastlogdic[id] = true
	print("(Daily Task "+str(id)+") INFO: Complete")
	


func _on_edit_pressed() -> void: #Requests to edit
	Input.action_press("Edit")
	Input.action_release("Edit")
	rtv.edittarget = id
	rtv.isediting = true
	print("(Daily Task "+str(id)+") INFO: Requested edit")



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
