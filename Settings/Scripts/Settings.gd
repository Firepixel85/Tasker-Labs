extends Control

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var warning: Label = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Control/HBoxContainer2/Warning


signal settings_changed
#-----Settings------#

@onready var time_setting: OptionButton = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/Label2/HBoxContainer/Time Setting"
@onready var username: LineEdit = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/Label2/HBoxContainer/Username


#-----End-----#
var past_settings:Dictionary
var settings:Dictionary
var applied:bool


func _ready() -> void:
	warning.set_warn("")
	animator.play("Closed")

func enter():
	begin_setting()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Settings") and rtv.iscreating == false and rtv.isediting == false and rtv.issetting == false:
		begin_setting()


func begin_setting():
	applied = false
	animator.play("In")
	rtv.issetting = true
	past_settings = rtv.settings
	settings = rtv.settings
	time_setting.select(settings["time_setting"])
	username.text = settings["username"]
	
func apply():
	if  username.text == "":
		warning.set_warn("Nickname can't be empty!")
	else:
		settings["time_setting"] = time_setting.selected
		settings["username"] = username.text
		applied = true
		rtv.settings = settings

func on_apply_pressed() -> void:
	apply()



func on_done_pressed() -> void:
	if applied == true and username.text != "":
		animator.play("Out")
		rtv.issetting = false
		settings_changed.emit()
		animator.play("Out")
		rtv.issetting = false
	else:
		warning.set_warn("Click again to exit without saving.")
		applied = true
