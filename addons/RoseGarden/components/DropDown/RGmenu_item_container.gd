extends VBoxContainer

signal _highlighted(id:int)

func _get_min_size():
	@warning_ignore("shadowed_global_identifier")
	var max := 0
	for child in get_children():
		if child.size.x > max:
			max = child.size.x
	return max+6


func _on_child_entered_tree(node: Node) -> void:
	await node.ready
	node._highlighted.connect(highlighted)
	

func highlighted(id:int):
	_highlighted.emit(id)
