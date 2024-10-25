extends Control

var colorpointer:Dictionary = {0:"res://Daily Task/Textures/Colors/Big/Blue.svg", 1:"res://Daily Task/Textures/Colors/Big/Green.svg", 2:"res://Daily Task/Textures/Colors/Big/Orange.svg", 3: "res://Daily Task/Textures/Colors/Big/Pink.svg",4:"res://Daily Task/Textures/Colors/Big/Red.svg",5:"res://Daily Task/Textures/Colors/Big/Teal.svg"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg",5:"res://Daily Task/Textures/Icons/Big/Mindful.svg",6:"res://Daily Task/Textures/Icons/Big/Dollar.svg"}

@onready var warn: Label = $"../Warnings"
@onready var warntimer: Timer = $"../Warnings/warntimer"

@onready var cancel = $TextureRect/HBoxContainer/MarginContainer/HBoxContainer/Cancel
@onready var create = $TextureRect/HBoxContainer/MarginContainer/HBoxContainer/Create
@onready var daily_handler = $"../Daily Ui"
@onready var delete = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer2/Delete

@onready var taskname = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer/LineEdit
@onready var taskcolor = $"TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Color Drop Down"
@onready var taskicon = $"TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Icon Drop Down"

@onready var colordisplay = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/Color
@onready var icondisplay = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/HBoxContainer/VBoxContainer/Icon

func _ready():
	visible = false
	taskcolor.add_icon_item(load("res://Daily Task/Textures/Colors/Blue.png"),"Blue",0)
	taskcolor.add_icon_item(load("res://Daily Task/Textures/Colors/Green.png"),"Green",1)
	taskcolor.add_icon_item(load("res://Daily Task/Textures/Colors/Orange.png"),"Orange",2)
	taskcolor.add_icon_item(load("res://Daily Task/Textures/Colors/Pink.png"),"Pink",3)
	taskcolor.add_icon_item(load("res://Daily Task/Textures/Colors/Red.png"),"Red",4)
	taskcolor.add_icon_item(load("res://Daily Task/Textures/Colors/Teal.png"),"Teal",5)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Dumbell.svg"),"Dumbell",1)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Book.svg"),"Book",2)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Paw.svg"),"Paw",3)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Paintbrush.svg"),"Paintbrush",4)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Mindful.svg"),"Mindful",4)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Dollar.svg"),"Dollar",4)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Cancel") and rtv.isediting == true:
		_on_cancel_pressed()
	colordisplay.texture = load(colorpointer[taskcolor.selected])
	icondisplay.texture = load(iconpointer[taskicon.selected+1])
	if Input.is_action_just_pressed("Edit"):
		taskname.grab_focus()
		visible = true
		taskname.text = rtv.namedic[rtv.edittarget]
		taskcolor.select(int(rtv.colordic[rtv.edittarget])-1)
		taskicon.select(int(rtv.icondic[rtv.edittarget])-1)

func _on_cancel_pressed() -> void:
	visible = false
	rtv.edittarget = "0"
	rtv.isediting = false


func _on_create_pressed() -> void:
	if taskname.text != "":
		rtv.namedic[rtv.edittarget] = taskname.text
		rtv.colordic[rtv.edittarget] = taskcolor.selected +1
		rtv.icondic[rtv.edittarget] = taskicon.selected +1
		visible = false
		rtv.edittarget = "0"
		rtv.isediting = false
	elif taskname.text == "":
		warn.setwarn("Task name can't be empty!")
		warntimer.start()
		await warntimer.timeout
		warn.clearwarn()


func _on_delete_pressed() -> void:
	rtv.deletetarget = rtv.edittarget
	rtv.namedic.erase(rtv.edittarget)
	rtv.colordic.erase(rtv.edittarget)
	rtv.icondic.erase(rtv.edittarget)
	rtv.donedic.erase(rtv.edittarget)
	rtv.streakdic.erase(rtv.edittarget)
	rtv.comlastlogdic.erase(rtv.edittarget)
	rtv.iddic.erase(rtv.edittarget)
	visible = false
	rtv.edittarget = "0"
	rtv.isediting = false
