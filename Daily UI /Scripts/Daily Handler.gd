extends Control

signal new_task(id:int)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_task(taskname,taskcolor,taskicon):
	var targetid = rtv.lastgivenid + 1
	rtv.namedic[str(targetid)] = taskname
	rtv.colordic[str(targetid)] = taskcolor +1
	rtv.icondic[str(targetid)] = taskicon +1
	rtv.donedic[str(targetid)] = false
	rtv.streakdic[str(targetid)] = 0
	rtv.iddic[str(targetid)] = str(targetid)
	rtv.comlastlogdic[str(targetid)] = false
	rtv.lastgivenid = targetid
	rtv.justcreatedid = rtv.lastgivenid
	new_task.emit(rtv.lastgivenid)
