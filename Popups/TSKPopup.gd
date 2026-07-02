extends Node
class_name TSKPopup

const NO_ACTION:int = 0
const SINGLE_ACTION:int = 1
const DOUBLE_ACTION:int = 2

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

func add_action(action:Callable, params:Array=[]):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if actions.size() >= type:
		return ERR_ALREADY_EXISTS
	actions.append(action)
	action_params.append(params)
	return OK

func set_action(index:int, action:Callable, params:Array=[]):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if index < 0 or index >= type:
		return ERR_INVALID_PARAMETER
	actions[index] = action
	action_params[index] = params
	return OK

func add_action_name(p_name:String):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if action_names.size() >= type:
		return ERR_ALREADY_EXISTS
	action_names.append(p_name)
	return OK

func set_action_name(index:int, p_name:String):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if index < 0 or index >= type:
		return ERR_INVALID_PARAMETER
	action_names[index] = p_name
	return OK

func add_color(color:String):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if colors.size() >= type:
		return ERR_ALREADY_EXISTS
	if RoseGarden.Colors.verify_color(color) != OK:
		return ERR_INVALID_PARAMETER
	colors.append(color)
	return OK

func set_color(index:int, color:String):
	if type == NO_ACTION:
		return ERR_INVALID_PARAMETER
	if index < 0 or index >= type:
		return ERR_INVALID_PARAMETER
	if RoseGarden.Colors.verify_color(color) != OK:
		return ERR_INVALID_PARAMETER
	colors[index] = color
	return OK

func _init():
	actions = []
	action_params = []
	action_names = []
	colors = []
