extends VBoxContainer

func add_option(option_id:String,option_scene:Resource):
	var option_instance = option_scene.instantiate()
	option_instance.name = option_id
	add_child(option_instance)
	return get_children()[get_child_count()-1]

func remove_option(option_id:String):
	for child in get_children():
		if child.name == option_id:
			remove_child(child)
			child.queue_free()
			return OK
	return ERR_DOES_NOT_EXIST
