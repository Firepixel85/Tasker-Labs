extends HBoxContainer


@onready var sidebar_selection: OptionButton = $"../Sidebar selection Method/Label2/HBoxContainer/Sidebar Selection"

func _process(delta: float) -> void:
	
	if rtv.issetting == true and sidebar_selection.selected == 1 or sidebar_selection.selected == 2:
		visible = true
	else:
		visible = false
