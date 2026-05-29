extends Control
class_name Notification
@onready var container: Control = $RGContainer
@onready var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var title: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var margin_container: MarginContainer = $RGContainer/MarginContainer
@onready var progress: TextureProgressBar = $VBoxContainer/TextureProgressBar
@onready var button: Button = $Button

var action
var action_params
var duration

signal closed

func _update():
	size.y = margin_container.size.y + 16
	container.size.x = 448
	progress.get_parent().size.x = 448
	button.size.x = 448
	size.x = 448

func _second_update():
	custom_minimum_size.y = margin_container.size.y + 16
	container._update()

func setup(new_title:String,new_description:String,error:=false,new_action=null,new_action_params:=[],new_duration:=4.0):
	title.set_text(new_title)
	description.text = new_description
	if error:
		icon.texture = Icons.WARNING
		progress.texture_progress = load("res://Notifications/GlowRed.png")
	else:
		icon.texture = Icons.BELL
		progress.texture_progress = load("res://Notifications/Glow"+Settings.get_option_value("core.appearance/accent_color")+".png")
	action = new_action
	action_params = new_action_params
	duration = new_duration
	enter()
	_update()
	await get_tree().process_frame #Needs to update 2 times to properly size
	_second_update()
	if duration == 0:
		return OK
	var tween = create_tween()
	tween.tween_property(progress,"value",0,duration)
	await tween.finished
	close()
	return OK

func close():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	closed.emit()


func enter():
	var tween = create_tween()
	tween.tween_property(self,"position:x",0,0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func _on_button_pressed() -> void:
	if action != null:
		action.callv(action_params)
	close()
