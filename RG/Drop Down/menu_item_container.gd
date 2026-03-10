extends VBoxContainer

func _get_min_size():
	var max := 0
	for child in get_children():
		if child.size.x > max:
			max = child.size.x
	return max+6
