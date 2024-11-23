extends Control

signal new_task(id:int)

#Smooth Scrolling:
@onready var scroll_container: SmoothScrollContainer = $Incomplete/MarginContainer/VBoxContainer/Control/ScrollContainer2
@onready var scroll_container_done: SmoothScrollContainer = $Complete/MarginContainer/VBoxContainer/Control/ScrollContainer2
var profile = {"smooth":load("res://Scroll Profiles/Smooth.tres"),"standard":load("res://Scroll Profiles/Standard.tres")}

func add_task(taskname,taskcolor,taskicon):
	print("(Daily Handler) INFO: Recieved task data from New task")
	var targetid = rtv.lastgivenid + 1
	rtv.streakdic[str(targetid)] = 0
	rtv.namedic[str(targetid)] = taskname
	rtv.colordic[str(targetid)] = taskcolor 
	rtv.icondic[str(targetid)] = taskicon +1
	rtv.donedic[str(targetid)] = false
	rtv.iddic[str(targetid)] = str(targetid)
	rtv.comlastlogdic[str(targetid)] = false
	rtv.lastgivenid = targetid
	rtv.justcreatedid = rtv.lastgivenid
	if rtv.production == true:
		if rtv.namedic[str(targetid)].split(",")[1].split(":")[0] == "{strk}":
			rtv.streakdic[str(targetid)] = int(rtv.namedic[str(targetid)].split(",")[1].split(":")[1])
			rtv.namedic[str(targetid)] = rtv.namedic[str(targetid)].split(",")[0]
	if rtv.namedic[str(targetid)] == "{dropdata}":
		rtv.streakdic.clear()
		rtv.namedic.clear()
		rtv.colordic.clear()
		rtv.icondic.clear()
		rtv.donedic.clear()
		rtv.iddic.clear()
		rtv.comlastlogdic.clear()
	print("(Daily Handler) INFO: Signal sent to instantiators")
	new_task.emit(rtv.lastgivenid)
