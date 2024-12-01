extends Control

var colorpointer:Dictionary = {0:"res://Daily Task/Textures/Colors/Big/Blue.png", 1:"res://Daily Task/Textures/Colors/Big/Green.png", 2:"res://Daily Task/Textures/Colors/Big/Orange.png", 3: "res://Daily Task/Textures/Colors/Big/Pink.png",4:"res://Daily Task/Textures/Colors/Big/Red.png",5:"res://Daily Task/Textures/Colors/Big/Teal.png"}
var containerpointer:Dictionary ={0:"res://New Task/Textures/Containers/Blue.png",1:"res://New Task/Textures/Containers/Green.png",2:"res://New Task/Textures/Containers/Orange.png",3:"res://New Task/Textures/Containers/Pink.png",4:"res://New Task/Textures/Containers/Red.png",5:"res://New Task/Textures/Containers/Teal.png"}
var iconpointer:Dictionary = {2:"res://Daily Task/Textures/Icons/Big/Book.svg",1:"res://Daily Task/Textures/Icons/Big/Dumbell.svg",4:"res://Daily Task/Textures/Icons/Big/Paintbrush.svg",3:"res://Daily Task/Textures/Icons/Big/Paw.svg",5:"res://Daily Task/Textures/Icons/Big/Mindful.svg",6:"res://Daily Task/Textures/Icons/Big/Dollar.svg"}
@onready var pop_up: Control = $"../Pop Up"

@onready var warn: Label = $"../Warnings"
@onready var warntimer: Timer = $"../Warnings/warntimer"

@onready var cancel: Button = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/Cancel
@onready var edit: Button = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer2/HBoxContainer/Edit

@onready var daily_handler = $"../Daily Ui"
@onready var delete = $TextureRect/HBoxContainer/MarginContainer/VBoxContainer2/Delete
@onready var animator: AnimationPlayer = $AnimationPlayer

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
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Mindful.svg"),"Mindful",4)
	taskicon.add_icon_item(load("res://Daily Task/Textures/Icons/Dollar.svg"),"Dollar",4)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Cancel") and rtv.isediting == true:
		_on_cancel_pressed()
	colordisplay.texture = load(colorpointer[taskcolor.selected])
	icondisplay.texture = load(iconpointer[taskicon.selected+1])
	container.texture = load(containerpointer[taskcolor.selected])
	if Input.is_action_just_pressed("Edit"):
		animator.play("In")
		visible = true
		taskname.text = rtv.namedic[rtv.edittarget]
		taskcolor.select(int(rtv.colordic[rtv.edittarget]))
		taskicon.select(int(rtv.icondic[rtv.edittarget])-1)
		print("(Edit) INFO: Edit request accepted")

func _on_cancel_pressed() -> void:
	rtv.edittarget = "0"
	rtv.isediting = false
	animator.play("Out")
	await  animator.animation_finished
	visible = false



func _on_create_pressed() -> void:
	print("(Edit) INFO: Edit completion requested")
	if taskname.text != "" and taskname.text.split("").size() <= 36:
		rtv.namedic[rtv.edittarget] = taskname.text
		rtv.colordic[rtv.edittarget] = taskcolor.selected 
		rtv.icondic[rtv.edittarget] = taskicon.selected +1
		rtv.edittarget = "0"
		rtv.isediting = false
		animator.play("Out")
		print("(Edit) INFO: Edit completion accepted")
		await animator.animation_finished
		visible = false


	elif taskname.text == "":
		var tween = get_tree().create_tween()
		print("(Edit) INFO: Edit completion aborted")
		edit.modulate = Color(1, 0.27, 0.27)
		tween.tween_property(edit,"position",Vector2(175,0),0.08)
		tween.tween_property(edit,"position",Vector2(160,0),0.1)
		tween.tween_property(edit,"position",Vector2(145,0),0.08)
		tween.tween_property(edit,"position",Vector2(160,0),0.1)
		tween.tween_property(edit,"modulate",Color(1, 1, 1),0.1)
		pop_up.make_popup("Error!","Task name can't be empty.")
		
	elif taskname.text.split("").size() > 36:
		print("(Edit) INFO: Edit completion aborted")
		var tween = get_tree().create_tween()
		edit.modulate = Color(1, 0.27, 0.27)
		tween.tween_property(edit,"position",Vector2(175,0),0.08)
		tween.tween_property(edit,"position",Vector2(160,0),0.1)
		tween.tween_property(edit,"position",Vector2(145,0),0.08)
		tween.tween_property(edit,"position",Vector2(160,0),0.1)
		tween.tween_property(edit,"modulate",Color(1, 1, 1),0.1)
		pop_up.make_popup("Error!","Task name can't be longet than 36 characters.")

func _on_delete_pressed() -> void:
	print("(Edit) INFO: Deleting task: "+str(rtv.edittarget))
	rtv.deletetarget = rtv.edittarget
	rtv.namedic.erase(rtv.edittarget)
	rtv.colordic.erase(rtv.edittarget)
	rtv.icondic.erase(rtv.edittarget)
	rtv.donedic.erase(rtv.edittarget)
	rtv.streakdic.erase(rtv.edittarget)
	rtv.comlastlogdic.erase(rtv.edittarget)
	rtv.iddic.erase(rtv.edittarget)
	rtv.edittarget = "0"
	rtv.isediting = false
	animator.play("Out")
	await animator.animation_finished
	visible = false
