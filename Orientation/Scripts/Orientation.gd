extends Control

var page:int = 1
signal orientationcomp
@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var username: LineEdit = $"Page 2/MarginContainer/VBoxContainer/LineEdit"
@onready var timesetting: OptionButton = $"Page 3/MarginContainer/VBoxContainer/OptionButton"

func _ready() -> void:
	if rtv.orientationcomp == true:
		visible = false
	else:
		visible = true
	timesetting.add_item("Yes please, in MM:HH!", 1)
	timesetting.add_item("Yes please, in MM:HH:SS!", 2)
	timesetting.add_item("No thanks!", 0)
func _on_next_pressed() -> void:
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
		page += 1
		animator.play("Page"+str(page))
		
	
