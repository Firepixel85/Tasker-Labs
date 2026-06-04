extends Control
@onready var seperator: NinePatchRect = $MarginContainer/NinePatchRect

func _ready() -> void:
	RoseGarden.custom_textures_changed.connect(_update_textures)

func _update_textures():
	seperator.texture = load(RoseGarden._get_file_path()+"RightClickMenu/Seperator.svg")
