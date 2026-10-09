@tool
extends RGText

func tween_counter(target_text: String, duration: float = 1.0, transition: Tween.TransitionType = Tween.TRANS_LINEAR, ease_type: Tween.EaseType = Tween.EASE_IN_OUT) -> Tween:
	var start_seconds := _time_to_seconds(text)
	var end_seconds := _time_to_seconds(target_text)

	var tween := create_tween()
	tween.set_trans(transition)
	tween.set_ease(ease_type)
	tween.tween_method(_update_display, start_seconds, end_seconds, duration)

	return tween


func _update_display(current_seconds: float) -> void:
	text = _seconds_to_time(int(round(current_seconds)))
	
func _time_to_seconds(time_str: String) -> int:
	var parts := time_str.split(":")
	var seconds := 0

	match parts.size():
		2:
			seconds = int(parts[0]) * 60 + int(parts[1])
		3: 
			seconds = int(parts[0]) * 3600 + int(parts[1]) * 60 + int(parts[2])
		_:
			push_warning("tween_counter: expected 'MM:SS' or 'HH:MM:SS' format, got '%s'" % time_str)

	return seconds


func _seconds_to_time(total_seconds: int, force_hours: bool = false) -> String:
	total_seconds = max(total_seconds, 0)
	@warning_ignore("integer_division")
	var hours := total_seconds / 3600
	@warning_ignore("integer_division")
	var minutes := (total_seconds % 3600) / 60
	var seconds := total_seconds % 60

	if hours > 0 or force_hours:
		return "%02d:%02d:%02d" % [hours, minutes, seconds]
	return "%02d:%02d" % [minutes, seconds]
