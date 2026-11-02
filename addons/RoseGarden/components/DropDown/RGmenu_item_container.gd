extends VBoxContainer

signal _highlighted(id:int)

func _get_min_size():
	@warning_ignore("shadowed_global_identifier")
	var max := 0.0
	for child in get_children():
		if child.get_min_size() > max:
			max = child.get_min_size()
	return max


func _on_child_entered_tree(node: Node) -> void:
	await node.ready
	node._highlighted.connect(highlighted)
	

func highlighted(id:int):
	_highlighted.emit(id)
