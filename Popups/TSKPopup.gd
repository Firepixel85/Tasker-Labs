extends Node
class_name TSKPopup

const NO_ACTION:int = 0
const SINGLE_ACTION:int = 1
const DOUBLE_ACTION:int = 2

const ALIGNMENT_LEFT:int = 0
const ALIGNMENT_CENTER:int = 1
const ALIGNMENT_RIGHT:int = 2


var type:int = 0:
	set(value):
		if value < NO_ACTION or value > DOUBLE_ACTION:
			return
		type = value
var title:String = ""
var description:String = ""
var actions:Array = []:
	set(value):
		if type == NO_ACTION:
			return
		if value.size() > type:
			return
		for action in value:
			if !action is Callable:
				return
		actions = value
var action_params:Array = []:
	set(value):
		if type == NO_ACTION:
			return
		if value.size() > type:
			return
		for params in value:
			if !params is Array:
				return
		action_params = value
var action_names:Array = []:
	set(value):
		if type == NO_ACTION:
			return
		if value.size() > type:
			return
		for name in value:
			if !name is String:
				return
		action_names = value
var colors:Array = []:
	set(value):
		if type == NO_ACTION:
			return
		if value.size() > type:
			return
		for color in value:
			if RoseGarden.Colors.verify_color(color) != OK:
				return
		colors = value
var title_alignment:int = ALIGNMENT_CENTER:
	set(value):
		if value < ALIGNMENT_LEFT or value > ALIGNMENT_RIGHT:
			return
		title_alignment = value
var description_alignment:int = ALIGNMENT_LEFT:
	set(value):
		if value < ALIGNMENT_LEFT or value > ALIGNMENT_RIGHT:
			return
		description_alignment = value
var show_close_button:bool = true

func set_title(text:String):
	title = text
	return OK

func set_description(text:String):
	description = text
	return OK

func set_type(p_type:int):
	if p_type < NO_ACTION or p_type > DOUBLE_ACTION:
		return ERR_INVALID_PARAMETER
	type = p_type
	return OK

func hide_close_button():
	show_close_button = false
	return OK

func add_action(action:Callable, name:String, params:Array=[], color:String="White"):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if actions.size() >= type:
		return ERR_ALREADY_EXISTS
	if RoseGarden.Colors.verify_color(color) != OK:
		return ERR_INVALID_PARAMETER
	actions.append(action)
	action_params.append(params)
	action_names.append(name)
	colors.append(color)
	return OK

func set_action(index:int, action:Callable, name:String, params:Array=[], color:String="White"):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if index < 0 or index >= type:
		return ERR_INVALID_PARAMETER
	if RoseGarden.Colors.verify_color(color) != OK:
		return ERR_INVALID_PARAMETER
	actions[index] = action
	action_params[index] = params
	action_names[index] = name
	colors[index] = color
	return OK

func _init():
	actions = []
	action_params = []
	action_names = []
	colors = []
	title_alignment = ALIGNMENT_CENTER
	description_alignment = ALIGNMENT_LEFT
	show_close_button = true
	title = ""
	description = ""
