extends Control

signal new_task(id:int)



func add_task(taskname,taskcolor,taskicon):
	var targetid = rtv.lastgivenid + 1
	
	rtv.streakdic[str(targetid)] = 0
	rtv.namedic[str(targetid)] = taskname
	rtv.colordic[str(targetid)] = taskcolor +1
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
		
	new_task.emit(rtv.lastgivenid)
