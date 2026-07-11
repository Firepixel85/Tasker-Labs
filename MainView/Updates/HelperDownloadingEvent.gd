extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var glow: TextureProgressBar = $RGContainer/VBoxContainer/Glow

func _ready() -> void:
	animation_player.play("loop")
	glow.texture_progress = load("res://MainView/Updates/Textures/Glow%s.png"%Settings.get_option_value("core.appearance/accent_color"))
