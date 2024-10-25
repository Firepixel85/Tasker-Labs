extends VBoxContainer
@export var comp:bool
func _ready() -> void:
	for i in rtv.namedic.size():
		var array = rtv.iddic.values()
		rtv.loadcreationstatus_overview = 0
		rtv.justcreatedid_overview = array[i]
		if comp == false:
			add_child(preload("res://Overview/Task/Overview Task.tscn").instantiate())
		else:
			add_child(preload("res://Overview/Task/Overview Task Done.tscn").instantiate())
		await rtv.loadcreationstatus_overview == 1
		
func add_task(id):
	rtv.justcreatedid_overview = id
	if comp == false:
		add_child(preload("res://Overview/Task/Overview Task.tscn").instantiate())
	else:
		add_child(preload("res://Overview/Task/Overview Task Done.tscn").instantiate())
