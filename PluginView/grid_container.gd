extends GridContainer

const CHILD_WIDTH: float = 512.0

func _ready() -> void:
	resized.connect(_update_columns)
	_update_columns()

func _update_columns() -> void:
	var available_width: float = get_parent_area_size().x
	var h_sep: float = float(get_theme_constant("h_separation"))
	var col_width: float = CHILD_WIDTH + h_sep
	var fitting_columns: int = floori((available_width + h_sep) / col_width)
	columns = max(1, fitting_columns)
