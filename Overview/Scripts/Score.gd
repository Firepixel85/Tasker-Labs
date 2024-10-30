extends TextureProgressBar

@onready var text: Label = $Label
@onready var timer: Timer = $Timer


func animate_value():
	if rtv.iddic.size() != 0:
		var count:int
		for i in rtv.namedic.size():
			var array = rtv.iddic.values()
			if rtv.donedic[array[i]] == true:
				count += 1
		value = 0
		timer.start()
		await timer.timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self,"value",(100 * count) / rtv.iddic.size(),0.6).set_trans(Tween.TRANS_SINE)

		text.text = str((100 * count) / rtv.iddic.size())+"%"
