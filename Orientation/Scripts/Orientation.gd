extends Control

var page:int = 1
var anim_protection = false #Stops process() from hidding before an animation is finished
signal orientationcomp
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var username: LineEdit = $"Page 2/MarginContainer/VBoxContainer/LineEdit"
@onready var timesetting: OptionButton = $"Page 3/MarginContainer/VBoxContainer/OptionButton"
@onready var hint: TextureRect = $"Next Button/HBoxContainer/MarginContainer/Button2/Button/Hint"

func _ready() -> void:
	if rtv.orientationcomp == true:
		visible = false
		hint.stop()
	else:
		visible = true
		hint._ready()
	timesetting.add_item("No thanks!", 0)
	timesetting.add_item("Yes please, in MM:HH!", 1)
	timesetting.add_item("Yes please, in MM:HH:SS!", 2)
	timesetting.select(1)
	animator.play("RESET")
	page = 1
	


func _on_next_pressed() -> void:
	if page == 1:
		hint.stop()
		username.grab_focus()
	if page == 3:
		rtv.settings["time_setting"] = timesetting.selected
	if page == 4:
		rtv.orientationcomp = true
		orientationcomp.emit()
	if page != 2:
		page += 1
		animator.play("Page"+str(page))
	elif username.text != "":
		rtv.settings["username"]  = username.text
		username.text = ""
		timesetting.select(1)
		page += 1
		anim_protection = true
		animator.play("Page"+str(page))
		await animator.animation_finished
		anim_protection = false
		
	

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Enter") and orientationcomp:
		_on_next_pressed() 
	if rtv.orientationcomp and anim_protection == false:
		visible = false
func _on_settings_reorientate() -> void:
	_ready()
