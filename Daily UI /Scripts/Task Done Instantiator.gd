extends VBoxContainer

func _ready():
	if rtv.isloading == true:
		loadfull()



func loadfull():
	for i in rtv.namedic.size():
		var array = rtv.iddic.values()
		rtv.loadcreationstatus = 0
		rtv.justcreatedid = array[i-1]
		add_child(preload("res://Daily Task/Daily Task Done/Daily Task Done.tscn").instantiate())
		await rtv.loadcreationstatus == 1

func new_task(id: int) -> void:
	add_child(preload("res://Daily Task/Daily Task Done/Daily Task Done.tscn").instantiate())
	rtv.justcreatedid = id
