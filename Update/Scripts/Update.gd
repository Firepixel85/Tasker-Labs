extends Control

@onready var web: HTTPRequest = $HTTPRequest
@onready var exit: Button = $VBoxContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer2/Control/HBoxContainer2/Button
@onready var update: Button = $VBoxContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer2/Control/HBoxContainer/Button
@onready var text: Label = $VBoxContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/Label2
@onready var title: Label = $VBoxContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/Label

var user
var found_updater:bool
func _ready() -> void:
	user = OS.get_user_data_dir().split("/")[2]
func _on_exit_pressed() -> void:
	visible = false


func _on_update_pressed() -> void:
	var output = []
	var con = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && cd 'Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker' && ls"],output)
	
	exit.visible = false
	update.visible = false
	text.text = "Downloading updating tool"
	title.text = "Updating"
	for i in str(output).split("\\n").size():
		if str(output).split("\\n")[i] == "[\"Updater.app":
			found_updater = true
			print("found")
			
	
	if not found_updater or rtv.updater_latest_version != rtv.updater_version:
		print("not found, downloading")
		web.set_download_file("user://Updater.zip")
		web.request("https://github.com/Firepixel85/Tasker-Labs/releases/download/latest_pointer/Updater.Mac.zip")
		
		var term
		await web.request_completed
		
		if rtv.os == "MAC":
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && unzip '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.zip' -d  '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker'"],output)
			term = OS.execute("/bin/bash",["-c"]+["cd .. && cd .. && cd .. && cd .. && cd .. && rm '/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.zip'"],output)
		elif rtv.os == "WIN":
			term = OS.execute("POWERSHELL.exe", ["tar -xf C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker\\Updater.zip -C C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker"],output)
			term = OS.execute("POWERSHELL.exe", ["Remove-Item -Path C:\\Users\\"+user+"\\AppData\\Roaming\\Godot\\app_userdata\\Tasker\\Updater.zip"],output)
			var timer = get_tree().create_timer(1)
			await timer.timeout
	
	OS.shell_open("/Users/"+user+"/Library/Application Support/Godot/app_userdata/Tasker/Updater.app")
	get_tree().quit()


func _on_visibility_changed() -> void:
	if rtv.latest_version != null:
		text.text = "Tasker version "+rtv.latest_version+" is available and you are running version "+rtv.version+". Do you want to update?"
