extends Control

var lastgivenid:int = 0

signal new_task(id:int)
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_task(taskname,taskcolor,taskicon):
	var targetid = lastgivenid + 1
	rtv.namedic[targetid] = taskname
	rtv.colordic[targetid] = taskcolor +1
	rtv.icondic[targetid] = taskicon +1
	lastgivenid = targetid
	rtv.justcreatedid = lastgivenid
	new_task.emit(lastgivenid)
