extends OptionButton

@export var target_setting:String
@export var options:Array


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in options.size():
		add_item(options[i],i)
