extends Control

var colorpointer:Dictionary = {0:"res://Daily Task/Textures/Colors/Big/Blue.png", 1:"res://Daily Task/Textures/Colors/Big/Green.png", 2:"res://Daily Task/Textures/Colors/Big/Orange.png", 3: "res://Daily Task/Textures/Colors/Big/Pink.png",4:"res://Daily Task/Textures/Colors/Big/Red.png",5:"res://Daily Task/Textures/Colors/Big/Teal.png"}
var containerpointer:Dictionary ={0:"res://New Task/Textures/Containers/Blue.png",1:"res://New Task/Textures/Containers/Green.png",2:"res://New Task/Textures/Containers/Orange.png",3:"res://New Task/Textures/Containers/Pink.png",4:"res://New Task/Textures/Containers/Red.png",5:"res://New Task/Textures/Containers/Teal.png"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg",5:"res://Daily Task/Textures/Icons/Big/Mindful.svg",6:"res://Daily Task/Textures/Icons/Big/Dollar.svg"}

@onready var warn: Label = $"../Warnings"
@onready var pop_up: Control = $"../Pop Up"
@onready var warntimer: Timer = $"../Warnings/warntimer"

@onready var animator = $AnimationPlayer
@onready var cancel = $TextureRect/HBoxContainer/MarginContainer/HBoxContainer/Cancel
@onready var create = $TextureRect/HBoxContainer/MarginContainer/HBoxContainer/Control/Create
@onready var daily_handler = $"../Daily Ui"

@onready var taskname = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer/LineEdit
@onready var taskcolor = $"TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Color Drop Down"
@onready var taskicon = $"TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Icon Drop Down"

@onready var colordisplay = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/Color
@onready var icondisplay = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Control/Color/HBoxContainer/VBoxContainer/Icon
@onready var container: TextureRect = $TextureRect

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
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Mindful.svg"),"Mindful",5)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Dollar.svg"),"Dollar",6)

func _process(_delta):
	container.texture = load(containerpointer[taskcolor.selected])
	colordisplay.texture = load(colorpointer[taskcolor.selected])
	icondisplay.texture = load(iconpointer[taskicon.selected+1])
	if Input.is_action_just_pressed("Add") and rtv.iscreating == false:
		clearsel()
		rtv.iscreating = true
		visible = true
		animator.play("RESET")
		animator.play("In")
		print("(New task) INFO: Creating")
	if Input.is_action_just_pressed("Cancel") and rtv.iscreating == true:
		rtv.iscreating = false
		animator.play("Out_Canceled")
		print("(New task) INFO: Creation canceled")
		await animator.animation_changed
		visible = false
	if Input.is_action_just_pressed("Enter") and rtv.iscreating == true:
		_on_create_pressed()
		
	
func _on_cancel_pressed():
	if rtv.iscreating == true:
		Input.action_press("Cancel")
		Input.action_release("Cancel")

func _on_create_pressed():
	print("(New task) INFO: Requested completion")
	if rtv.iscreating == true and taskname.text != "" and taskname.text.split("").size() <= 36:
		print("(New task) INFO: Completion request accepted")
		var tween = get_tree().create_tween()
		tween.tween_property(create,"scale",Vector2(1.1,1.1),0.2)
		tween.tween_property(create,"scale",Vector2(1,1),0.2)
		print("(New task) INFO: Sending task data to Daily Handler")
		daily_handler.add_task(taskname.text,taskcolor.selected,taskicon.selected)
		animator.play("Out_Complete")
		await animator.animation_changed
		visible = false
		rtv.iscreating = false

	elif taskname.text == "":
		var tween = get_tree().create_tween()
		print("(New task) INFO: Completion aborted")
		create.modulate = Color(1, 0.27, 0.27)
		tween.tween_property(create,"position",Vector2(15,0),0.08)
		tween.tween_property(create,"position",Vector2(0,0),0.1)
		tween.tween_property(create,"position",Vector2(-15,0),0.08)
		tween.tween_property(create,"position",Vector2(0,0),0.1)
		tween.tween_property(create,"modulate",Color(1, 1, 1),0.1)
		pop_up.make_popup("Error!","Task name can't be empty.")

	elif taskname.text.split("").size() > 36:
		print("(New task) INFO: Completion aborted")
		var tween = get_tree().create_tween()
		create.modulate = Color(1, 0.27, 0.27)
		tween.tween_property(create,"position",Vector2(15,0),0.08)
		tween.tween_property(create,"position",Vector2(0,0),0.1)
		tween.tween_property(create,"position",Vector2(-15,0),0.08)
		tween.tween_property(create,"position",Vector2(0,0),0.1)
		tween.tween_property(create,"modulate",Color(1, 1, 1),0.1)
		pop_up.make_popup("Error!","Task name can't be longet than 36 characters.")

		

func clearsel():
	taskname.grab_focus()
	taskname.text = ""
	taskcolor.selected = 0
	taskicon.selected = 0

var clo = Color(1, 0.5, 0.575, 1)
