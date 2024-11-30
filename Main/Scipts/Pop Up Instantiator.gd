extends Control

@onready var vbox: VBoxContainer = $MarginContainer/VBoxContainer
signal clicked
func make_popup(popup_name:String,popup_desc:String):
	rtv.pop_up_name = popup_name
	rtv.pop_up_desc = popup_desc
	vbox.add_child(preload("res://Pop Up/Pop Up.tscn").instantiate())




func pop_up_made(node: Node) -> void:
	var popup = node.get_path()
	node.custom_minimum_size = Vector2(0,102)
	
func _process(delta: float) -> void:
	if rtv.popup_clicked == true:
		rtv.popup_clicked = false
		clicked.emit()
