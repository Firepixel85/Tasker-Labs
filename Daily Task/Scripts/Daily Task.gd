extends Control

var colorpointer:Dictionary = {1:"res://Daily Task/Textures/Colors/Big/Blue.svg", 2:"res://Daily Task/Textures/Colors/Big/Green.svg", 3:"res://Daily Task/Textures/Colors/Big/Orange.svg", 4: "res://Daily Task/Textures/Colors/Big/Pink.svg",5:"res://Daily Task/Textures/Colors/Big/Red.svg",6:"res://Daily Task/Textures/Colors/Big/Teal.svg"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg"}
@onready var taskname = $"Container/Task Left/MarginContainer/VBoxContainer/Name"
@onready var taskcolor = $"Container/Task Left/Color"
@onready var taskicon = $"Container/Task Left/Color/VBoxContainer/HBoxContainer/Icon"
@onready var taskstreak = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Count"
@onready var taskflame = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Button"

@onready var done: Button = $"Container/Task Right/Buttons/Buttons/Done Container/Done"
@onready var edit: Button = $"Container/Task Right/Buttons/Buttons/Edit Container/Edit"

var id:String
func _ready():
	if rtv.justcreatedid != -1:
		id = str(rtv.justcreatedid)
		rtv.justcreatedid = -1
		if rtv.streakstatus == "hold" and rtv.comlastlogdic[id] == false:
			rtv.streakdic[id] = 0
		elif rtv.streakstatus == "kill":
			rtv.streakdic[id] = 0
			rtv.comlastlogdic[id] = false
		if rtv.streakstatus == "hold":
			rtv.donedic[id] = false
			rtv.comlastlogdic[id] = false
		
		taskname.text = rtv.namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		rtv.loadcreationstatus = 0
		rtv.iscreating = false

		if rtv.streakdic[id] <= 7:
			taskflame.modulate = Color8(84,157,246)
		elif rtv.streakdic[id] > 7 and rtv.streakdic[id] <= 15:
			taskflame.modulate = Color8(255,159,10)
		elif rtv.streakdic[id] > 15 :
			taskflame.modulate = Color8(246,94,84)
		
		if rtv.donedic[id] == false:
			visible = true
		else:
			visible = false
			
		
	else:
		print("Fatal Error: Task data lost!")
	
func _process(delta: float) -> void:
	taskname.text = rtv.namedic[id]
	taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
	taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
	taskstreak.text = str(rtv.streakdic[id])
	if rtv.donedic[id] == false:
		visible = true
	else:
		visible = false



func _on_done_pressed() -> void:
	visible = false
	rtv.streakdic[id] += 1
	rtv.donedic[id] = true
	rtv.comlastlogdic[id] = true


func _on_edit_pressed() -> void:
	Input.action_press("Edit")
	Input.action_release("Edit")
	print("sending")
	rtv.edittarget = id
	rtv.isediting = true
