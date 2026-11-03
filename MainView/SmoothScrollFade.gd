extends SmoothScrollContainer

@export var top_texture: TextureRect
@export var bottom_texture: TextureRect
@export_range(0.01, 0.5) var fade_zone: float = 0.1  # 10% of the scroll range

var _last_above := -1.0
var _last_below := -1.0


func _ready() -> void:
	super()  # keep the plugin's own setup running
	# Poll every frame: the smooth position changes continuously and the
	# scrollbar signals don't track it. Connecting to the SceneTree avoids
	# overriding _process(), which the plugin uses for its own animation.
	get_tree().process_frame.connect(_update_fade)
	_update_fade()


func _update_fade() -> void:
	var content := _get_content()
	var max_scroll := 0.0
	if content:
		max_scroll = content.size.y - size.y

	# Nothing to scroll: hide both indicators
	if max_scroll <= 0.0:
		_apply_alpha(0.0, 0.0)
		return

	# scroll_vertical is the plugin's smoothed position (it may briefly go
	# out of range during overscroll, hence the clamp)
	var ratio := clampf(float(scroll_vertical) / max_scroll, 0.0, 1.0)

	# near the top (10% -> 0%): more content below  => alpha 0 -> 1
	var more_below := clampf(remap(ratio, fade_zone, 0.0, 0.0, 1.0), 0.0, 1.0)
	# near the bottom (90% -> 100%): more content above => alpha 0 -> 1
	var more_above := clampf(remap(ratio, 1.0 - fade_zone, 1.0, 0.0, 1.0), 0.0, 1.0)

	_apply_alpha(more_above, more_below)


func _get_content() -> Control:
	for child in get_children():
		if child is Control and child.visible:
			return child
	return null


func _apply_alpha(above: float, below: float) -> void:
	# Skip redundant writes while the scroll position isn't changing
	if is_equal_approx(above, _last_above) and is_equal_approx(below, _last_below):
		return
	_last_above = above
	_last_below = below
	_set_alpha(top_texture, above)
	_set_alpha(bottom_texture, below)


func _set_alpha(node: TextureRect, alpha: float) -> void:
	if node:
		node.modulate = Color(1, 1, 1, alpha)
