extends Control

@onready var animator: AnimationPlayer = $AnimationPlayer
signal settings_changed
#-----Settings------#

@onready var time_setting: OptionButton = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/Label2/HBoxContainer/Time Setting"
@onready var username: LineEdit = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/Label2/HBoxContainer/Username


#-----End-----#
var past_settings:Dictionary
var applied:bool


func _ready() -> void:
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
	time_setting.select(rtv.settings["time_setting"])
	username.text = rtv.settings["username"]
	
func apply():
	applied = true
	rtv.settings["time_setting"] = time_setting.selected
	rtv.settings["username"] = username.text

func on_apply_pressed() -> void:
	apply()


func on_done_pressed() -> void:
	animator.play("Out")
	rtv.issetting = false
	if applied == true:
		settings_changed.emit()



func on_cancel_pressed() -> void:
	if applied == true:
		rtv.settings = past_settings
	animator.play("Out")
	rtv.issetting = false
