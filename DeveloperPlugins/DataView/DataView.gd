extends Control

const ID = "com.rosepen.dataview"
@onready var files_container: VBoxContainer = $VBoxContainer/MarginContainer2/ScrollContainer/VBoxContainer
@onready var file_view: MarginContainer = $VBoxContainer/MarginContainer2
@onready var controls: MarginContainer = $VBoxContainer/MarginContainer
@onready var code_view: MarginContainer = $VBoxContainer/MarginContainer3
@onready var code: CodeEdit = $VBoxContainer/MarginContainer3/CodeEdit
@onready var save: RGButton = $VBoxContainer/MarginContainer/HBoxContainer/Save
@onready var delete_button: RGButton = $VBoxContainer/MarginContainer/HBoxContainer/Delete

var files:Array = [] 
var open_file:String = ""
func _ready() -> void:
	code.syntax_highlighter = JsonSyntaxHighlighter.new()
	await get_tree().process_frame
	refresh()
	

func refresh():
	for child in files_container.get_children():
		child.queue_free()
	files = []
	await get_tree().process_frame
	for file in Data.actual_file_path.keys():
		if Data.file_exists(file):
			files.append(Data.actual_file_path[file].lstrip("user://"))
	for file in files:
		var node = load(PluginManager.get_plugin_filepath(ID)+"File.tscn").instantiate()
		files_container.add_child(node)
		node.setup(file)
		node.open.connect(open)

func open(file:String):
	controls.show()
	save.icon = Icons.SAVECHECK
	open_file = file
	file_view.hide()
	code_view.show()
	code.text = format_json(str(JSON.parse_string(FileAccess.open("user://%s"%file,FileAccess.READ).get_as_text())))
	code.clear_undo_history()

func close():
	refresh()
	controls.hide()
	file_view.show()
	code_view.hide()
	open_file = ""

func format_json(json_text: String, indent: String = "  ") -> String:
	var validator := JSON.new()
	if validator.parse(json_text) != OK:
		push_error("JsonFormatter: invalid JSON (line %d): %s" % [
			validator.get_error_line(),
			validator.get_error_message(),
		])
		return json_text
 
	var out := PackedStringArray()
	var depth := 0
	var in_string := false
	var escaped := false
	var length := json_text.length()
	var i := 0
 
	while i < length:
		var c: String = json_text[i]
 
		# Inside a string: copy everything verbatim until the closing quote.
		if in_string:
			out.append(c)
			if escaped:
				escaped = false
			elif c == "\\":
				escaped = true
			elif c == "\"":
				in_string = false
			i += 1
			continue
 
		match c:
			"\"":
				in_string = true
				out.append(c)
			"{", "[":
				var closer: String = "}" if c == "{" else "]"
				var next := _skip_whitespace(json_text, i + 1)
				if next < length and json_text[next] == closer:
					# Empty container: keep it as {} or [].
					out.append(c + closer)
					i = next
				else:
					depth += 1
					out.append(c + "\n" + indent.repeat(depth))
			"}", "]":
				depth -= 1
				out.append("\n" + indent.repeat(depth) + c)
			",":
				out.append(",\n" + indent.repeat(depth))
			":":
				out.append(": ")
			" ", "\t", "\n", "\r":
				pass # Drop original whitespace outside of strings.
			_:
				out.append(c)
		i += 1
 
	return "".join(out)
 
 
func _skip_whitespace(text: String, from: int) -> int:
	var i := from
	while i < text.length() and text[i] in [" ", "\t", "\n", "\r"]:
		i += 1
	return i
 

func _on_code_edit_text_changed() -> void:
	save.icon = Icons.SAVE

func _on_save_pressed() -> void:
	if open_file == "":
		return
	code.clear_undo_history()
	save.icon = Icons.SAVECHECK
	var file = FileAccess.open("user://"+open_file,FileAccess.WRITE)
	file.store_string(code.text)
	file.close()

func delete(file:String):
	if file == "":
		return
	Data.remove_file(file.rstrip(".json"))
	await get_tree().process_frame
	close()

func empty(): # I am bored of making these
	pass

func _on_delete_pressed() -> void:
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.DOUBLE_ACTION)
	popup.set_title("Delete file?")
	popup.title_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.set_description("Deleting this file permenantly erases data in an intrucive way, part of the app may not respond well or crash.")
	popup.description_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.hide_close_button()
	popup.add_action(empty,"Cancel",[],"Gray")
	popup.add_action(delete,"Delete",[open_file],"Red")
	Popups.create_prefab_popup(popup)

func _on_delete_hovered() -> void:
	delete_button.set_color("Red")

func _on_delete_de_hovered() -> void:
	delete_button.set_color("Gray")

func _process(delta: float) -> void:
	if Sidebar.get_selected_tab() != ID or Main.get_current_view() != "mainview":
		return
	if Input.is_action_just_pressed("save_changes"):
		RoseGarden.create_toast("File saved","Green")
		_on_save_pressed()
	if Input.is_action_just_pressed("delete_file"):
		_on_delete_pressed()
	if Input.is_action_just_pressed("view_close") and !Popups.is_popup_active():
		close()


func _on_code_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_RIGHT and event.pressed:
		var menu = RGmenu.new()
		menu.add_action("Cut",load("res://addons/RoseGarden/icons/Scissors.svg"),code.cut)
		menu.add_action("Copy",load("res://addons/RoseGarden/icons/Copy.svg"),code.copy)
		menu.add_action("Paste",load("res://addons/RoseGarden/icons/Clipboard.svg"),code.paste)
		menu.add_seperator()
		menu.add_action("Select All",load("res://addons/RoseGarden/icons/TextCursor.svg"),code.select_all)
		menu.add_action("Clear",load("res://addons/RoseGarden/icons/X.svg"),code.clear)
		menu.add_seperator()
		menu.add_action("Undo",load("res://addons/RoseGarden/icons/Undo.svg"),code.undo)
		menu.add_action("Redo",load("res://addons/RoseGarden/icons/Redo.svg"),code.redo)
		RoseGarden.create_rc_menu(menu,get_global_mouse_position())
