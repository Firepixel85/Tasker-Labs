extends ScrollContainer

@export var top_texture: TextureRect
@export var bottom_texture: TextureRect
@export_range(0.01, 0.5) var fade_zone: float = 0.1  # 10% of the scroll range


func _ready() -> void:
	var bar := get_v_scroll_bar()
	bar.value_changed.connect(_update_fade.unbind(1))
	bar.changed.connect(_update_fade)  # fires when content/page size changes
	_update_fade()


func _update_fade() -> void:
	var bar := get_v_scroll_bar()
	var max_scroll := bar.max_value - bar.page

	# Nothing to scroll: hide both indicators
	if max_scroll <= 0.0:
		_set_alpha(top_texture, 0.0)
		_set_alpha(bottom_texture, 0.0)
		return

	var ratio := clampf(bar.value / max_scroll, 0.0, 1.0)

	# scroll 10% -> 0%  =>  alpha 0 -> 1
	var top_alpha := clampf(remap(ratio, fade_zone, 0.0, 0.0, 1.0), 0.0, 1.0)
	# scroll 90% -> 100%  =>  alpha 0 -> 1
	var bottom_alpha := clampf(remap(ratio, 1.0 - fade_zone, 1.0, 0.0, 1.0), 0.0, 1.0)

	_set_alpha(bottom_texture, top_alpha)
	_set_alpha(top_texture, bottom_alpha)


func _set_alpha(node: TextureRect, alpha: float) -> void:
	if node:
		node.modulate = Color(1, 1, 1, alpha)
