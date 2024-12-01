extends TextureProgressBar

@onready var text: Label = $"../Label"
@onready var timer: Timer = $Timer


func animate_value(changed:bool):
	modulate = Color(rtv.settings["accent_color"])
	if rtv.iddic.size() != 0:
		var count:int
		for i in rtv.namedic.size():
			var array = rtv.iddic.values()
			if rtv.donedic[array[i]] == true:
				count += 1
		if changed == false:
			value = 0
		timer.start()
		await timer.timeout
		var tween = get_tree().create_tween()
		if changed == false:
			tween.tween_property(self,"value",(100 * count) / rtv.iddic.size(),0.6).set_trans(Tween.TRANS_SINE)
		else:
			tween.tween_property(self,"value",(100 * count) / rtv.iddic.size(),0.3).set_trans(Tween.TRANS_SINE)
		text.text = str((100 * count) / rtv.iddic.size())+"%"
	else:
		value = 0
		text.text = "0%"
