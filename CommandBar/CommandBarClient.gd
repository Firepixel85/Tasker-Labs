extends Control
@onready var command_container: VBoxContainer = $NinePatchRect/MarginContainer/CommandContainer
@onready var selection: NinePatchRect = $NinePatchRect/MarginContainer/VBoxContainer/Selection
@onready var container: NinePatchRect = $NinePatchRect
@onready var margin_container: MarginContainer = $NinePatchRect/MarginContainer
@onready var highlight: NinePatchRect = $NinePatchRect/MarginContainer/VBoxContainer2/Highlight

const ID = "core.command_bar"
var input:RGTextFieldIcon

var command_amount:int = 0
var commands:Array = []
var command_names:Dictionary = {}
var command_icons:Dictionary = {}
var command_actions:Dictionary = {}
var command_params:Dictionary = {}
var command_points:Dictionary = {}
var command_keywords:Dictionary = {}

signal command_added(path:String)
signal command_removed(path:String)
signal command_executed(path:String)
signal command_hidden(path:String)
signal command_shown(path:String)

var is_bar_open:bool = false
func _display_command(title:String,icon_path:String,path:String):
	command_container.add_child(preload("res://CommandBar/Command.tscn").instantiate())
	var target:Command = command_container.get_child(command_container.get_child_count()-1)
	target.hovered.connect(_highlighted)
	target.selected.connect(_select)
	target.execute.connect(execute_command)
	target.manager = self
	target.init(title,icon_path,path)

func _update():
	size.y = margin_container.get_minimum_size().y
	margin_container.position.y = 0
	create_tween().tween_property(container,"size:y",size.y,0.1*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _ready():
	CommandBar._client = self

func _input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed:
		return
	match event.keycode:
		KEY_UP:
			if selection.position.y == 0:
				return
			create_tween().tween_property(selection,"position:y",selection.position.y-68,0.1*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			get_viewport().set_input_as_handled()
		KEY_DOWN:
			if selection.position.y == (command_container.get_child_count()-1)*68:
				return
			create_tween().tween_property(selection,"position:y",selection.position.y+68,0.1*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			get_viewport().set_input_as_handled()

func _highlighted(pos_y):
	var tween = create_tween()
	tween.tween_property(highlight,"position:y",pos_y,0.07*int(Settings.get_option_value("core.appearance/more_animations"))*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	highlight.show()
	await tween.finished

func _select(pos_y):
	var tween = create_tween()
	tween.tween_property(selection,"position:y",pos_y,0.12*int(!RoseGarden.Accessibility.disableAnimations)*int(Settings.get_option_value("core.appearance/more_animations"))).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	input.edit()

func command_has_focus() -> bool:#Checking if the command bar has focus will return false, but command buttons can grab focus and the command bar shouldn't close
	for command in command_container.get_children():
		if command.custom_minimum_size.x == 1:#The "NoResults" scene has a cms.x of 1 to tell it apart from a normal command, using the name doesn't always work
			return false
		if command.button.has_focus():return true
	return false

func _process(_delta: float) -> void:
	if !visible:return
	if get_global_mouse_position().y<get_global_transform().origin.y or get_global_mouse_position().x<get_global_transform().origin.x or get_global_mouse_position().x > get_global_transform().origin.x+container.size.x or get_global_mouse_position().y>get_global_transform().origin.y+container.size.y:
		highlight.hide()
	elif selection.visible:
		highlight.show()

func open():
	is_bar_open = true
	command_amount = Settings.get_option_value("core.general/command_amount")
	for child in command_container.get_children():
		child.queue_free()
	var command_list = _get_relevant_commands(input.get_text())
	for command in command_list:
		_display_command(command_names[command],command_icons[command],command)
	await get_tree().process_frame
	await get_tree().process_frame
	_update()
	show()
	highlight.show()
	selection.show()
	create_tween().tween_property(self,"modulate",Color(1,1,1),0.2*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func update_shown_commands():
	command_amount = Settings.get_option_value("core.general/command_amount")
	var command_list = _get_relevant_commands(input.get_text())
	if command_list.size() == 0:
		command_container.get_child(0).set_no_results(true)
		selection.hide()
		highlight.hide()
		for i in range(1,command_container.get_child_count()):
			command_container.get_child(i).queue_free()
	elif command_list.size() > command_container.get_child_count():
		for i in range(command_container.get_child_count()):
			command_container.get_child(i).init(command_names[command_list[i]],command_icons[command_list[i]],command_list[i])
		for i in range(command_container.get_child_count(),command_list.size()):
			_display_command(command_names[command_list[i]],command_icons[command_list[i]],command_list[i])
		selection.show()
		highlight.show()
	elif command_list.size() < command_container.get_child_count():
		for i in range(command_list.size()):
			command_container.get_child(i).init(command_names[command_list[i]],command_icons[command_list[i]],command_list[i])
		for i in range(command_list.size(),command_container.get_child_count()):
			command_container.get_child(i).queue_free()
		selection.show()
		highlight.show()
	elif command_list.size() == command_container.get_child_count():
		for i in range(command_list.size()):
			command_container.get_child(i).init(command_names[command_list[i]],command_icons[command_list[i]],command_list[i])
		selection.show()
		highlight.show()

	await get_tree().process_frame
	await get_tree().process_frame
	_update()

func close():
	is_bar_open = false
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.2*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	hide()

func add_command(command_name:String,id:String,icon_path:String,action:Callable,params:Array=[],keywords=[]):
	var path = id+"/"+command_name
	if commands.has(path):
		Debug.warn("Process: "+Main.get_process_name(id)+" tried to add a command that already exists: "+path,ID)
		return ERR_ALREADY_EXISTS
	if !ResourceLoader.exists(icon_path):
		Debug.warn("Process: "+Main.get_process_name(id)+" tried to add a command with an invalid icon path: "+icon_path,ID)
		return ERR_FILE_NOT_FOUND
	if !load(icon_path) is CompressedTexture2D:
		Debug.warn("Process: "+Main.get_process_name(id)+" tried to add a command with an icon path that isn't a texture: "+path,ID)
		return ERR_INVALID_DATA
	commands.append(path)
	command_names[path] = command_name
	command_icons[path] = icon_path
	command_actions[path] = action
	command_params[path] = params
	command_keywords[path] = keywords
	if !command_points.has(path):
		command_points[path] = 0
	command_added.emit(path)
	save()
	Debug.log("Command added by process: "+Main.get_process_name(id)+", path is: "+path,ID)
	return path

func remove_command(path:String):
	var id = path.split("/")[0]
	if !commands.has(path):
		Debug.warn("Process: "+Main.get_process_name(id)+" tried to remove a command that doesn't exist: "+path,ID)
		return ERR_DOES_NOT_EXIST
	commands.erase(path)
	command_names.erase(path)
	command_icons.erase(path)
	command_actions.erase(path)
	command_params.erase(path)
	command_points.erase(path)
	command_removed.emit(path)
	save()
	Debug.log("Command removed by process: "+Main.get_process_name(id),ID)
	return OK

func hide_command(path:String):
	var id = path.split("/")[0]
	if !commands.has(path):
		Debug.warn("Process: "+Main.get_process_name(id)+" tried to hide a command that doesn't exist: "+path,ID)
		return ERR_DOES_NOT_EXIST
	commands.erase(path)
	command_hidden.emit(path)
	save()
	Debug.log("Command hidden by process: "+Main.get_process_name(id),ID)
	return OK

func show_command(path:String):
	var id = path.split("/")[0]
	if commands.has(path):
		Debug.warn("Process: "+Main.get_process_name(id)+" tried to show a command that doesn't exist: "+path,ID)
		return ERR_ALREADY_EXISTS
	commands.append(path)
	command_shown.emit(path)
	save()
	Debug.log("Command shown by process: "+Main.get_process_name(id),ID)
	return OK

func link_action(action:Callable,path:String):
	if !command_names.has(path):
		Debug.warn("Tried to link an action to a command that doesn't exist: "+path,ID)
		return ERR_DOES_NOT_EXIST
	Debug.log("Linked action to command: "+path,ID)
	command_actions[path] = action
	return OK

func command_has_action(path:String):
	return command_actions.has(path)

func command_exists(path:String):
	return command_names.has(path)

func _get_relevant_commands(input_text:String):
	var command_list:Array = []
	var command_score = []
	if input_text == "":
		for i in range(commands.size()):
			if command_list.size()<command_amount:
				command_list.append(commands[i])
				command_score.append(command_points[commands[i]])
			elif command_points[command_list[command_list.size()-1]]<command_points[commands[i]]:
				command_list[command_list.size()-1] = commands[i]
				command_score[command_list.size()-1] = command_points[commands[i]]
			_sort_parallel_arrays(command_score,command_list)
	else:
		var mapped_points = _map_points()
		for i in range(commands.size()):
			var score = 0.0
			var substring = float(_is_substring(command_names[commands[i]].to_lower(),input_text.to_lower()))
			if input_text.to_lower() == command_names[commands[i]].to_lower():
				score = 10
			elif command_names[commands[i]].to_lower().begins_with(input_text.to_lower()):
				score = 8
			elif _get_acronym(command_names[commands[i]].to_lower()) == input_text.to_lower():
				score = 7
			elif _get_acronym(command_names[commands[i]].to_lower()).begins_with(input_text.to_lower()):
				score = 6
			elif substring != 0:
				score = substring/2
			if score == 0:
				for word in command_keywords[commands[i]]:
					if word.to_lower() == input_text.to_lower():
						score = 7
						break
			if score != 0:
				score += mapped_points[commands[i]]
				score = clamp(score,0,10)
				if command_list.size()<command_amount:
					command_list.append(commands[i])
					command_score.append(score)
				elif command_score[command_score.size()-1]<score:
					command_list[command_score.size()-1] = commands[i]
					command_score[command_score.size()-1] = score
			_sort_parallel_arrays(command_score,command_list)
	return command_list

func _is_substring(haystack:String,needle:String):
	var found_index = haystack.find(needle)
	if found_index != -1:
		var length_difference = haystack.length() - needle.length()
		if length_difference == 1:
			return false
		else:
			return length_difference
	else:
		return false

func _sort_parallel_arrays(values_array: Array, items_array: Array) -> void:
	if values_array.size() != items_array.size():
		Debug.error("Tried to sort parallel arrays of different sizes in CommandBarClient",ID)
		return
	if values_array.is_empty():
		return
	var paired_data: Array = []
	for i in range(values_array.size()):
		paired_data.append({ "value": values_array[i], "item": items_array[i] })
	paired_data.sort_custom(Callable(self, "_compare_paired_data_by_value"))
	for i in range(paired_data.size()):
		values_array[i] = paired_data[i]["value"]
		items_array[i] = paired_data[i]["item"]

func _compare_paired_data_by_value(a: Dictionary, b: Dictionary) -> bool:
	return a["value"] > b["value"]

func _get_acronym(command_name:String):
	var acronym = ""
	for word in command_name.split(" "):
		acronym += word.split("")[0]
	return acronym

func execute_command(path:String):
	if !commands.has(path):
		Debug.warn("Tried to execute a command that doesn't exist: "+path,ID)
		return ERR_DOES_NOT_EXIST
	command_points[path] += 1
	command_executed.emit(path)
	command_actions[path].callv(command_params[path])
	input.close()
	save()
	return OK

func get_selected():
	for command in command_container.get_children():
		if command.position.y == selection.position.y:
			return command.path
	Debug.error("No command appears to be selected",ID)
	return commands[0]

func save():
	Data.save_to("command_points",command_points,"Core/CommandData")
	Data.save_file("Core/CommandData")

func load_commands():
	if Data.file_exists("Core/CommandData"):
		var data = Data.load_file("Core/CommandData")
		command_points = data["command_points"]
	else:
		Data.make_file("CommandData","Core")
		save()

func is_open():
	return is_bar_open

func _map_points():
	const map_to = 4
	var max_points = 0
	for command in commands:
		if command_points[command]>max_points:
			max_points = command_points[command]
	var mapped_points:Dictionary = {}
	if max_points == 0:
		return command_points
	for command in commands:
		mapped_points[command] = (map_to*command_points[command])/max_points
	return mapped_points
