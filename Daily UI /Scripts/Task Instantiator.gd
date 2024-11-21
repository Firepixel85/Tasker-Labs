extends VBoxContainer

func _ready(): 
	if rtv.isloading == true:
		loadfull()

func new_task(id):
	add_child(preload("res://Daily Task/Daily Task.tscn").instantiate())
	rtv.justcreatedid = id

func loadfull():
	for i in rtv.namedic.size():
		var array = rtv.iddic.values()
		rtv.loadcreationstatus = 0
		rtv.justcreatedid = array[i]
		add_child(preload("res://Daily Task/Daily Task.tscn").instantiate())
		await rtv.loadcreationstatus == 1
		


func _on_new_task(id: int) -> void:
	pass # Replace with function body.
