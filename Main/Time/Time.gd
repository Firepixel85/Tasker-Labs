extends VBoxContainer

@onready var time_label = $"MarginContainer/HBoxContainer/Time Label"
var time

func _ready() -> void:
	if rtv.lastlogwasloaded == true and rtv.lastlogd != Time.get_date_string_from_system():
		var ll = rtv.lastlogd.split("-")
		caldatedif(int(ll[0]),int(ll[1]),int(ll[2]))
	elif rtv.lastlogwasloaded == false:
		rtv.lastlogd = Time.get_date_string_from_system()
	else:
		rtv.streakstatus = "same"
	
func _process(_delta):

	time = Time.get_time_string_from_system().split(":")
	if rtv.settings["time_setting"] == 2:
		time_label.text = (time[0]+":"+time[1]+":"+time[2])
	elif rtv.settings["time_setting"] == 1:
		time_label.text = (time[0]+":"+time[1])
	else:
		time_label.text = ""
	if Input.is_action_pressed("Exit"):
		get_tree().quit()

func caldatedif(lly,llm,lld):
	var y = int(Time.get_date_string_from_system().split("-")[0])
	var m = int(Time.get_date_string_from_system().split("-")[1])
	var d = int(Time.get_date_string_from_system().split("-")[2])
	if (d == lld + 1 and lly == y) or (y == lly +1 and llm == 12 and lld == 31 and d == 1 and m == 1) or ((m == llm +1 and d == 1) and (lld == 31 or lld == 30 or lld == 28 or lld == 29) and lly == y):
		rtv.streakstatus = "hold"
	else: 
		rtv.streakstatus = "kill"
	rtv.lastlogd = Time.get_date_string_from_system()
