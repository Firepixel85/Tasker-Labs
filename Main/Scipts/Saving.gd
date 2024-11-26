extends TextureRect
@onready var savetimer: Timer = $Timer
@onready var web: HTTPRequest = $Timer/HTTPRequest

var console_callouts:bool = false
var latest:bool
func _ready() -> void:
	if FileAccess.file_exists("user://taskdata.json"):
		loadtaskdata()
		rtv.isloading = true
	if FileAccess.file_exists("user://lastlog.json"):
		rtv.lastlogwasloaded = true
		loadlastlog()
	if FileAccess.file_exists("user://orientation.json"):
		loadorientation()
	else:
		rtv.lastlogwasloaded = false
		var file = FileAccess.open("user://lastlog.json", FileAccess.WRITE)
		var save:Dictionary
		save["lastlogd"] = Time.get_date_string_from_system()
		var json = JSON.stringify(save)
		file.store_string(json)
		file.close()
	if FileAccess.file_exists("user://bg.jpg"):
		texture = ImageTexture.create_from_image(Image.load_from_file("user://bg.jpg"))
	savetimer.start()
	

	await  is_latest()
	if latest == false:
		print("(System) INFO: Running on older version!")
	else:
		print("(System) INFO: Applications is up-to-date")

	
func savetaskdata(): # Saves task data
	var file = FileAccess.open("user://taskdata.json", FileAccess.WRITE)
	var save:Dictionary
	save["namedic"] = rtv.namedic
	save["iddic"] = rtv.iddic 
	save["colordic"] = rtv.colordic
	save["icondic"] = rtv.icondic
	save["donedic"] = rtv.donedic
	save["streakdic"] = rtv.streakdic
	save["lastgivenid"] = rtv.lastgivenid
	save["complastlogdic"] = rtv.comlastlogdic
	var json = JSON.stringify(save)
	file.store_string(json)
	file.close()
	if console_callouts:
		print("(Saving) INFO: Saved taskdata")

func loadtaskdata(): #Loads task data
	var file = FileAccess.open("user://taskdata.json", FileAccess.READ)
	var json = file.get_as_text()
	var save = JSON.parse_string(json)
	rtv.namedic = save["namedic"]
	rtv.iddic = save["iddic"]
	rtv.colordic = save["colordic"] 
	rtv.icondic = save["icondic"] 
	rtv.donedic = save["donedic"] 
	rtv.streakdic = save["streakdic"]
	rtv.lastgivenid = save["lastgivenid"] 
	rtv.comlastlogdic = save["complastlogdic"]
	file.close()

	
	
func savelastlog(): # Saves lastlog data
	var file = FileAccess.open("user://lastlog.json", FileAccess.WRITE)
	var save:Dictionary
	save["lastlogd"] = rtv.lastlogd
	var json = JSON.stringify(save)
	file.store_string(json)
	file.close()
	if console_callouts:
		print("(Saving) INFO: Saved lastlog")

func saveorientation(): # Saves lastlog data
	var file = FileAccess.open("user://orientation.json", FileAccess.WRITE)
	var save:Dictionary
	save["orientationcomp"] = rtv.orientationcomp
	save["settings"] = rtv.settings
	var json = JSON.stringify(save)
	file.store_string(json)
	file.close()
	if console_callouts:
		print("(Saving) INFO: Saved orientation")

func loadlastlog(): #Loads lastlog data
	var file = FileAccess.open("user://lastlog.json", FileAccess.READ)
	var json = file.get_as_text()
	var save = JSON.parse_string(json)
	rtv.lastlogd = save["lastlogd"]
	file.close()
	
func loadorientation(): #Loads lastlog data
	var file = FileAccess.open("user://orientation.json", FileAccess.READ)
	var json = file.get_as_text()
	var save = JSON.parse_string(json)
	rtv.orientationcomp = save["orientationcomp"]

	rtv.settings = save["settings"]
	file.close()
	
func load_timeout() -> void:
	savetaskdata()
	savelastlog()
	savetimer.start()

func _on_orientationcomp() -> void:
	saveorientation()


func on_settings_changed() -> void:
	saveorientation()

func is_latest():
	web.set_download_file("user://latest_version.txt")
	web.request("https://github.com/Firepixel85/Tasker-Labs/releases/download/latest_pointer/latest_version.txt")
	await web.request_completed
	var latest_version = FileAccess.open("user://latest_version.txt",FileAccess.READ).get_as_text()
	print("(System) INFO: Current vesrion: "+ rtv.version+ " Latest version: "+ latest_version)
	if latest_version == rtv.version:
		latest = true
	else:
		latest = false
