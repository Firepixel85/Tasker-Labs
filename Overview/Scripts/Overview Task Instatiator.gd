extends VBoxContainer
@export var comp:bool
func _ready() -> void:
	if comp == false:
		print("(Overview Task Instantiator) INFO: Loading in full")
	for i in rtv.namedic.size():
		var array = rtv.iddic.values()
		rtv.loadcreationstatus_overview = 0
		rtv.justcreatedid_overview = array[i]
		if comp == false:
			add_child(preload("res://Overview/Task/Overview Task.tscn").instantiate())
		else:
			add_child(preload("res://Overview/Task/Overview Task Done.tscn").instantiate())
		await rtv.loadcreationstatus_overview == 1
	if not comp:
		print("(Overview Task Instantiator) INFO: Loaded full")
		
func add_task(id):
	rtv.justcreatedid_overview = id
	if comp == false:
		print("(Overview Task Instantiator) INFO: Recieved signal from Daily Handler")
		add_child(preload("res://Overview/Task/Overview Task.tscn").instantiate())
		print("(Overview Task Instantiator) INFO: Task Instantiated")
	else:
		add_child(preload("res://Overview/Task/Overview Task Done.tscn").instantiate())
