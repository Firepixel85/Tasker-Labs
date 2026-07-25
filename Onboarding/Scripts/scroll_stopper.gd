extends ScrollContainer

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	get_h_scroll_bar().mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_v_scroll_bar().mouse_filter = Control.MOUSE_FILTER_IGNORE

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index in [MOUSE_BUTTON_WHEEL_UP, MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_LEFT, MOUSE_BUTTON_WHEEL_RIGHT]:
			accept_event()
	elif event is InputEventMouseMotion and event.button_mask & MOUSE_BUTTON_MASK_LEFT:
		accept_event()
