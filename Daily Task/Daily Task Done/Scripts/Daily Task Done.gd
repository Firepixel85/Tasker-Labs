extends Control

var colorpointer:Dictionary = {1:"res://Daily Task/Textures/Colors/Big/Blue.svg", 2:"res://Daily Task/Textures/Colors/Big/Green.svg", 3:"res://Daily Task/Textures/Colors/Big/Orange.svg", 4: "res://Daily Task/Textures/Colors/Big/Pink.svg",5:"res://Daily Task/Textures/Colors/Big/Red.svg",6:"res://Daily Task/Textures/Colors/Big/Teal.svg"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg",5:"res://Daily Task/Textures/Icons/Big/Mindful.svg",6:"res://Daily Task/Textures/Icons/Big/Dollar.svg"}
@onready var taskname = $"Container/Task Left/MarginContainer/VBoxContainer/Name"
@onready var taskcolor = $"Container/Task Left/Color"
@onready var taskicon = $"Container/Task Left/Color/VBoxContainer/HBoxContainer/Icon"
@onready var taskstreak = $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Count"
@onready var taskflame= $"Container/Task Right/Streak/Streak Container/MarginContainer/Hbox/Vbox/Button"
var id:String
var deleted:bool
func _ready():
	if rtv.justcreatedid != -1:
		id = str(rtv.justcreatedid)

		taskname.text = rtv.namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		rtv.loadcreationstatus = 0
		rtv.iscreating = false
		
		update_streak_color()
			
		if rtv.donedic[id] == true:
			visible = true
		else:
			visible = false
		
	else:
		print("Fatal Error: Task data lost!")
	

func _process(delta: float) -> void:
	if rtv.deletetarget == id:
		visible= false
		deleted = true
	if deleted == false:
		update_streak_color()
		taskname.text = rtv.namedic[id]
		taskcolor.texture = load(colorpointer[int(rtv.colordic[id])])
		taskicon.texture = load(iconpointer[int(rtv.icondic[id])])
		taskstreak.text = str(rtv.streakdic[id])
		if rtv.donedic[id] == false:
			visible = false
		else:
			visible = true

func _on_edit_pressed() -> void:
	Input.action_press("Edit")
	Input.action_release("Edit")
	print("sending")
	rtv.edittarget = id
	rtv.isediting = true

func _on_x_button_pressed() -> void:
	visible = false
	rtv.streakdic[id] -= 1 
	rtv.donedic[id] = false
	rtv.comlastlogdic[id] = false

func update_streak_color():
	if deleted == false:
		if rtv.streakdic[id] <= 7:
			taskflame.modulate = Color8(84,157,246)
		elif rtv.streakdic[id] > 7 and rtv.streakdic[id] <= 15:
			taskflame.modulate = Color8(255,159,10)
		elif rtv.streakdic[id] > 15 :
			taskflame.modulate = Color8(246,94,84)
