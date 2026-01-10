@tool
extends Control

@onready var container: NinePatchRect = $ContainerTexture
@onready var options_cont: HBoxContainer = $OptionsContainer
@onready var selector_cont: VBoxContainer = $SelectorContainer
@onready var selector: NinePatchRect = $SelectionContainer/Control/SelectorTexture
@onready var options: HBoxContainer = $OptionsContainer/Options


@export var selected:int = 1
@export var options_list:Array = ["Option 1","Option 2"]
@export var reload_cont:bool = false

	
func _process(delta: float) -> void:
	if reload_cont == true:
		reload_cont = false
		reload()

func reload():
	print(options.get_children())
	remove_childern()
	print(options.get_children())
	add_optins()
	print(options.get_children())
	options_cont.size.x = options.size.x+16
	selector_cont.size = options_cont.size
	container.size = options_cont.size

func remove_childern():
	for child in options.get_children():
		options.remove_child(child)
		print("child deleted")
		
func add_optins():
	for item in options_list:
		options.add_child(preload("res://RG/Segment Control/label.tscn").instantiate())
		options.get_child(options.get_child_count()-1).text = str(item)
		print(get_child(options.get_child_count()-1).text)
