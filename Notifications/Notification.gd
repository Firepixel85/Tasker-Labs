extends Control
class_name Notification
@onready var container: Control = $RGContainer
@onready var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var title: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Title
@onready var margin_container: MarginContainer = $RGContainer/MarginContainer
@onready var progress: TextureProgressBar = $VBoxContainer/TextureProgressBar
@onready var button: Button = $Button
@onready var close_icon: Button = $CloseIcon

var action
var action_params
var duration

signal closed
signal sized
func _update():
	await get_tree().process_frame #
	await get_tree().process_frame #Don't ask me why it need this 2 times, Godot sizing logic is fucked (or i am dumb...)
	custom_minimum_size.y = margin_container.size.y + 16
	size = Vector2(448,margin_container.size.y)
	container._update()
	sized.emit()

func setup(new_title:String,new_description:String,error:=false,new_action=null,new_action_params:=[],new_duration:=4.0):
	modulate = Color(1,1,1,0)
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
	_update()
	await sized
	modulate = Color(1,1,1,1)
	enter()
	if duration == 0:
		return OK
	var tween = create_tween()
	tween.tween_property(progress,"value",0,duration)
	await tween.finished
	close(false)
	return OK

func close(was_desmised:bool):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	if was_desmised:
		tween.tween_property(self,"scale",Vector2(0,0),0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	else:
		tween.tween_property(self,"position:x",-448,0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	closed.emit()

func enter():
	position = Vector2(-448,0)
	var tween = create_tween()
	tween.tween_property(self,"position:x",0,0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func _on_button_pressed() -> void:
	if action != null:
		action.callv(action_params)
	close(true)

func _on_close_icon_mouse_entered() -> void:
	close_icon.icon = preload("res://Notifications/CloseHovered.svg")

func _on_close_icon_mouse_exited() -> void:
	close_icon.icon = preload("res://Notifications/Close.svg")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("notification_dismiss"):
		close(true)
