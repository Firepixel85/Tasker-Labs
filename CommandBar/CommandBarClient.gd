extends Control
@onready var command_container: VBoxContainer = $NinePatchRect/MarginContainer/CommandContainer
@onready var selection: NinePatchRect = $NinePatchRect/MarginContainer/VBoxContainer/Selection
@onready var container: NinePatchRect = $NinePatchRect
@onready var margin_container: MarginContainer = $NinePatchRect/MarginContainer
@onready var highlight: NinePatchRect = $NinePatchRect/MarginContainer/VBoxContainer2/Highlight

@export var commands:int = 0

var input:RGTextFieldIcon

func _ready():
	highlight.hide()
	for child in command_container.get_children():
		child.queue_free()
	for i in range(commands):
		_display_command()
	await get_tree().process_frame
	_update()

func _display_command():
	command_container.add_child(preload("res://CommandBar/Command.tscn").instantiate())
	var target:Command = command_container.get_child(command_container.get_child_count()-1)
	target.hovered.connect(_highlighted)
	target.selected.connect(_select)
	target.execute.connect(hide)
	target.manager = self

func _update():
	size.y = margin_container.size.y
	container.size.y = margin_container.size.y

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed:
		return
	match event.keycode:
		KEY_UP:
			if selection.position.y == 0:
				return
			create_tween().tween_property(selection,"position:y",selection.position.y-60,0.1*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			get_viewport().set_input_as_handled()
		KEY_DOWN:
			if selection.position.y == (commands-1)*60:
				return
			create_tween().tween_property(selection,"position:y",selection.position.y+60,0.1*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			get_viewport().set_input_as_handled()

func _highlighted(pos_y):
	create_tween().tween_property(highlight,"position:y",pos_y,0.07*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	highlight.show()

func _select(pos_y):
	var tween = create_tween()
	tween.tween_property(selection,"position:y",pos_y,0.12*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	input.edit()

func command_has_focus() -> bool:#Checking if the command bar has focus will return false, but command buttons can grab focus and the command bar shouldn't close
	for command in command_container.get_children():
		if command.button.has_focus():return true
	return false
	
func execute_command():
	input.close()

func _process(_delta: float) -> void:
	if !visible:return
	if get_global_mouse_position().y<position.y or get_global_mouse_position().x<position.x or get_global_mouse_position().y>position.y+size.y or get_global_mouse_position().x>position.x+size.x:
		highlight.hide()
	else:
		highlight.show()
