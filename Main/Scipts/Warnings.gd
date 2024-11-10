extends Label

func setwarn(warning):
	if rtv.iscreating == rtv.isediting == false:
		var tween = get_tree().create_tween()
		modulate = Color(1, 1, 1, 0)
		tween.tween_property(self,"modulate",Color(1, 1, 1),0.1)
		text = warning
	
func clearwarn():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"modulate",Color(1, 1, 1,0),0.1)
	await tween.finished
	text = ""
	
