extends VBoxContainer

func new_task(id):
	add_child(preload("res://Daily Task/Daily Task.tscn").instantiate())
	rtv.justcreatedid = id
