extends Control

var page:int = 1

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var username: LineEdit = $"Page 2/MarginContainer/VBoxContainer/LineEdit"
@onready var timesetting: OptionButton = $"Page 3/MarginContainer/VBoxContainer/OptionButton"

func _ready() -> void:
	timesetting.add_item("Yes please, in MM:HH!", 0)
	timesetting.add_item("Yes please, in MM:HH:SS!", 1)
	timesetting.add_item("No thanks!", 2)
func _on_next_pressed() -> void:
	if page == 3:
		rtv.timesetting = timesetting.selected
	if page != 2:
		page += 1
		animator.play("Page"+str(page))
	elif username.text != "":
		rtv.username = username.text
		page += 1
		animator.play("Page"+str(page))
	
