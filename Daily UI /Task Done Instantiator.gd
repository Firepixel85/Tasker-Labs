extends VBoxContainer

func _ready():
	if rtv.isloading == true:
		loadfull()

func new_task(id):
	add_child(preload("res://Daily Task/Daily Task Done/Daily Task Done.tscn").instantiate())
	rtv.justcreatedid = id

func loadfull():
	for i in rtv.namedic.size():
		rtv.loadcreationstatus = 0
		rtv.justcreatedid = i + 1
		add_child(preload("res://Daily Task/Daily Task Done/Daily Task Done.tscn").instantiate())
		await rtv.loadcreationstatus == 1
		
