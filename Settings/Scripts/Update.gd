extends TextureRect

@onready var web: HTTPRequest = $HTTPRequest
@onready var title: Label = $MarginContainer/VBoxContainer/Label
@onready var text: Label = $MarginContainer/VBoxContainer/Label2
var user
var found_updater
func _ready() -> void:
	user = OS.get_user_data_dir().split("/")[2]
func _process(delta: float) -> void:
	if rtv. latest_version != null:
		if rtv.settings["notify_for_updates"] and rtv.version != rtv.latest_version:
			visible = true
		else:
			visible = false


func _on_visibility_changed() -> void:
	if rtv. latest_version != null:
		text.text = "You are currently running version "+rtv.version+" of Tasker when "+rtv.latest_version+" is available!  Click here if you wish to update. You can disable this pop-up with the: \"Get notified of new versions\" setting." 


func _on_button_pressed() -> void:
	var output = []
	var term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && cd 'Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker' && ls"],output)
	

	text.text = "Downloading updating tool"
	title.text = "Updating"
	for i in str(output).split("\\n").size():
		if str(output).split("\\n")[i] == "[\"Updater.app":
			found_updater = true
			print("found")
			
	
	if not found_updater or rtv.updater_latest_version != rtv.updater_version:
		web.set_download_file("user://Updater.zip")

		delete_updater()
		if rtv.os == "MAC":
			
			
			web.request("https://github.com/Firepixel85/Tasker-Labs/releases/download/latest_pointer/Updater.Mac.zip")
			await web.request_completed
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && unzip '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.zip' -d  '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker'"],output)
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.zip'"],output)
		elif rtv.os == "WIN":
			delete_updater()
			web.request("https://github.com/Firepixel85/Tasker-Labs/releases/download/latest_pointer/Updater.Mac.zip")
			await web.request_completed
			term = OS.execute("POWERSHELL.exe", ["tar -xf C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker\\Updater.zip -C C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker"],output)
			term = OS.execute("POWERSHELL.exe", ["Remove-Item -Path C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker\\Updater.zip"],output)
			var timer = get_tree().create_timer(1)
			await timer.timeout
	
	OS.shell_open("/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.app")
	get_tree().quit()


func delete_updater():
	if rtv.os == "MAC":
		print("(System) INFO: Attempting to delete Updater")

		var output = []
		var term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm -rf '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.app'"],output)

		term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && cd '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker' && ls"],output)

		for i in str(output).split("\\n").size():
			if str(output).split("\\n")[i] == "[\"Updater.app":
				delete_updater()
				print("(System) INFO: Deletion Failed retrying")
	elif rtv.os == "WIN":
		print("(System) ERROR: Failed to delete Updater REASON: This feature is not available on windows")
