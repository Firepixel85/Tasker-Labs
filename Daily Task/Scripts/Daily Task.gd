extends Control

var colorpointer:Dictionary = {1:"res://Daily Task/Textures/Colors/Big/Blue.svg", 2:"res://Daily Task/Textures/Colors/Big/Green.svg", 3:"res://Daily Task/Textures/Colors/Big/Orange.svg", 4: "res://Daily Task/Textures/Colors/Big/Pink.svg",5:"res://Daily Task/Textures/Colors/Big/Red.svg",6:"res://Daily Task/Textures/Colors/Big/Teal.svg"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg"}
@onready var taskname = $"Container/Task Left/MarginContainer/VBoxContainer/Name"
@onready var taskcolor = $"Container/Task Left/Color"
@onready var taskicon = $"Container/Task Left/Color/VBoxContainer/HBoxContainer/Icon"

func _ready():
	if rtv.justcreatedid != -1:
		taskname.text = rtv.namedic[rtv.justcreatedid]
		taskcolor.texture = load(colorpointer[rtv.colordic[rtv.justcreatedid]])
		taskicon.texture = load(iconpointer[rtv.icondic[rtv.justcreatedid]])
		rtv.justcreatedid = -1
	else:
		print("Fatal Error: Task data lost!")


