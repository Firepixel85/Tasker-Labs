extends TextureRect
@onready var savetimer: Timer = $Timer

func _ready() -> void:
	if FileAccess.file_exists("user://taskdata.json"):
		loaddata()
		rtv.isloading = true
	savetimer.start()
	
func save(): # Saves task data
	var file = FileAccess.open("user://taskdata.json", FileAccess.WRITE)
	var save:Dictionary
	save["namedic"] = rtv.namedic
	save["colordic"] = rtv.colordic
	save["icondic"] = rtv.icondic
	save["donedic"] = rtv.donedic
	save["streakdic"] = rtv.streakdic
	save["lastgivenid"] = rtv.lastgivenid
	var json = JSON.stringify(save)
	file.store_string(json)
	file.close()

func loaddata(): #Loads task data
	var file = FileAccess.open("user://taskdata.json", FileAccess.READ)
	var json = file.get_as_text()
	var save = JSON.parse_string(json)
	rtv.namedic = save["namedic"]
	rtv.colordic = save["colordic"] 
	rtv.icondic = save["icondic"] 
	rtv.donedic = save["donedic"] 
	rtv.streakdic = save["streakdic"]
	rtv.lastgivenid = save["lastgivenid"] 
	file.close()
func load_timeout() -> void:
	save()
	savetimer.start()
