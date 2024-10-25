extends TextureProgressBar

@onready var text: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var score
	var count:int
	for i in rtv.namedic.size():
		var array = rtv.iddic.values()
		if rtv.donedic[array[i]] == true:
			count += 1
	if rtv.iddic.size() != 0:
		score = (100 * count) / rtv.iddic.size()
	if score != null:
		value = score
		text.text = str(value)+"%"
