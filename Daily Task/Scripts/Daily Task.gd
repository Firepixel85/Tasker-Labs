extends Control

var colorpointer:Dictionary = {1:"res://Daily Task/Textures/Colors/Big/Blue.svg", 2:"res://Daily Task/Textures/Colors/Big/Green.svg", 3:"res://Daily Task/Textures/Colors/Big/Orange.svg", 4: "res://Daily Task/Textures/Colors/Big/Pink.svg",5:"res://Daily Task/Textures/Colors/Big/Red.svg",6:"res://Daily Task/Textures/Colors/Big/Teal.svg"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg"}
@onready var taskname = $"Container/Task Left/MarginContainer/VBoxContainer/Name"
@onready var taskcolor = $"Container/Task Left/Color"
@onready var taskicon = $"Container/Task Left/Color/VBoxContainer/HBoxContainer/Icon"
@onready var taskstreak = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Count"
@onready var taskflame= $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Button"

func _ready():
	if rtv.justcreatedid != -1:
		taskname.text = rtv.namedic[str(rtv.justcreatedid)]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[str(rtv.justcreatedid)])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[str(rtv.justcreatedid)])])
		taskstreak.text = str(rtv.streakdic[str(rtv.justcreatedid)])
		rtv.loadcreationstatus = 0
		rtv.iscreating = false
		if rtv.streakdic[str(rtv.justcreatedid)] <= 7:
			taskflame.modulate = Color8(84,197,246)
		elif rtv.streakdic[str(rtv.justcreatedid)] > 7 and rtv.streakdic[str(rtv.justcreatedid)] <= 15:
			taskflame.modulate = Color8(255,159,10)
		elif rtv.streakdic[str(rtv.justcreatedid)] > 15 :
			taskflame.modulate = Color8(246,94,84)
		rtv.justcreatedid = -1
	else:
		print("Fatal Error: Task data lost!")
	
