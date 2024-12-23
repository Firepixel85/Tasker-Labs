extends Control

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var warning: Label = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/Control/HBoxContainer2/Warning


signal settings_changed
signal reorientate
#-----Settings------#

@onready var time_setting = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Show time/Label2/HBoxContainer/Time Setting"
@onready var username = $MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Nickname/Label2/HBoxContainer/Username
@onready var sidebar_selection: OptionButton = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Sidebar selection Method/Label2/HBoxContainer/Sidebar Selection"
@onready var accent_color: LineEdit = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Accent color/Label2/HBoxContainer/Color"
@onready var notify_for_updates: CheckButton = $"MarginContainer/TextureRect/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/Notify For Updates/Label2/HBoxContainer/CheckButton"

#-----End Settings-----#
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
	settings = rtv.settings
	time_setting.select(settings["time_setting"])
	username.text = settings["username"]
	sidebar_selection.select(settings["sidebar_selection"])
	accent_color.text = settings["accent_color"]
	notify_for_updates.button_pressed = settings["notify_for_updates"]
	
	
func apply():
	if  username.text == "" or accent_color.text == "" and accent_color.text.split().size() != 6:
		warning.set_warn("1 or more spaces have been left empty!")
	elif accent_color.text.split().size() != 6:
		warning.set_warn("Sidebar Selection Color needs to be 6 characters (HEX)")
	else: #Forwards new settings to the settings dictionary
		settings["sidebar_selection"] = sidebar_selection.selected
		settings["time_setting"] = time_setting.selected
		settings["username"] = username.text
		settings["accent_color"] = accent_color.text  
		settings["notify_for_updates"] = notify_for_updates.button_pressed
		applied = true
		rtv.settings = settings

func on_apply_pressed() -> void:
	apply()



func on_done_pressed() -> void:
	if (applied == true and username.text != "" and accent_color.text != "") or apply_pass == true:
		animator.play("Out")
		rtv.issetting = false
		settings_changed.emit()
	else:
		warning.set_warn("Click again to exit without saving.")
		apply_pass = true
		


func _on_open_aud_pressed() -> void:
	OS.shell_show_in_file_manager(OS.get_user_data_dir())


func _on_restart_orientation_pressed() -> void:
	rtv.orientationcomp = false
	rtv.settings["username"] = ""
	rtv.settings["time_setting"] = 0
	apply_pass = true
	on_done_pressed()
	reorientate.emit()
	settings_changed.emit()
