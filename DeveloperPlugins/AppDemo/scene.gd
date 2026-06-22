extends Control
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	texture_rect.texture = load(PluginManager.get_plugin_filepath("com.rosepen.app_demo")+"Demo.png")
