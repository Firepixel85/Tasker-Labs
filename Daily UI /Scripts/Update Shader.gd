extends TextureRect



func _process(delta: float) -> void:
	material.set_shader_parameter("width",size.x)
	material.set_shader_parameter("height",size.y)
