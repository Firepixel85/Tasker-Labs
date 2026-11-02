extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rect: ColorRect = $ColorRect

func play(anim:String):
	animation_player.play(anim)

func set_color(color:String):
	if color == "Red":
		rect.material.set_shader_parameter("outer_color",Color("d91405"))
		rect.material.set_shader_parameter("mid_color",Color("ff730a"))
		rect.material.set_shader_parameter("core_color",Color("ffe04d"))
	elif color == "Purple":
		rect.material.set_shader_parameter("outer_color",Color("351be0"))
		rect.material.set_shader_parameter("mid_color",Color("e13ae1"))
		rect.material.set_shader_parameter("core_color",Color("e1bbe1"))
	elif color == "Blue":
		rect.material.set_shader_parameter("outer_color",Color("#1C1BA6"))
		rect.material.set_shader_parameter("mid_color",Color("#1860DB"))
		rect.material.set_shader_parameter("core_color",Color("#09DFE0"))
		
func set_new_size(new_size:String):
	if new_size == "Small":
		rect.material.set_shader_parameter("flame_width",0.2)
		rect.material.set_shader_parameter("flame_height",0.4)
	elif new_size == "Big":
		rect.material.set_shader_parameter("flame_width",0.39)
		rect.material.set_shader_parameter("flame_height",0.97)

func _ready() -> void:
	var new_mat = ShaderMaterial.new()
	new_mat.shader = load("res://DeveloperPlugins/Habits/Flames/Flame.gdshader")
	new_mat.set_shader_parameter("turbulence",0.11)
	new_mat.set_shader_parameter("edge_softness",0.06)
	new_mat.set_shader_parameter("conrner_softness",0.6)
	rect.material = new_mat
