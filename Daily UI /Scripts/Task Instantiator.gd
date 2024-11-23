extends VBoxContainer

func _ready(): 
	if rtv.isloading == true:
		loadfull()

func new_task(id):
	print("(Task Instantiator) INFO: Recieved signal from Daily Handler")
	add_child(preload("res://Daily Task/Daily Task.tscn").instantiate())
	rtv.justcreatedid = id
	print("(Task Instantiator) INFO: Task instantiated")

func loadfull():
	print("(Task Instantiator) INFO: Loading in full")
	for i in rtv.namedic.size():
		var array = rtv.iddic.values()
		rtv.loadcreationstatus = 0
		rtv.justcreatedid = array[i]
		add_child(preload("res://Daily Task/Daily Task.tscn").instantiate())
		await rtv.loadcreationstatus == 1
	print("(Task Instantiator) INFO: Loaded full")
		
