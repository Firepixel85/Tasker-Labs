extends Control

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var warning: Label = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Control/HBoxContainer2/Warning


signal settings_changed
#-----Settings------#

@onready var time_setting = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Show time/Label2/HBoxContainer/Time Setting"
@onready var username = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Nickname/Label2/HBoxContainer/Username
@onready var sidebar_selection: OptionButton = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Sidebar selection style/Label2/HBoxContainer/Sidebar Selection"


#-----End-----#
var past_settings:Dictionary
var settings:Dictionary
var applied:bool
var apply_pass:bool = false

func _ready() -> void:
	warning.set_warn("")
	animator.play("Closed")

func enter():
	begin_setting()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Settings") and rtv.iscreating == false and rtv.isediting == false and rtv.issetting == false:
		begin_setting()



func begin_setting():
	apply_pass = false
	applied = false
	animator.play("In")
	rtv.issetting = true
	past_settings = rtv.settings
	settings = rtv.settings
	time_setting.select(settings["time_setting"])
	username.text = settings["username"]
	sidebar_selection.select(settings["sidebar_selection"])
	
func apply():
	if  username.text == "":
		warning.set_warn("Nickname can't be empty!")
	else:
		settings["sidebar_selection"] = sidebar_selection.selected
		settings["time_setting"] = time_setting.selected
		settings["username"] = username.text
		applied = true
		rtv.settings = settings

func on_apply_pressed() -> void:
	apply()



func on_done_pressed() -> void:
	if (applied == true and username.text != "") or apply_pass == true:
		animator.play("Out")
		rtv.issetting = false
		settings_changed.emit()
	else:
		warning.set_warn("Click again to exit without saving.")
		apply_pass = true
		
