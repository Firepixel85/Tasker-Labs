@tool
extends Window

# Emitted when the user confirms a selection, carrying the chosen .tscn path
signal component_selected(scene_path: String)

const COMPONENTS_ROOT = "res://addons/RoseGarden/components/"

@onready var search: LineEdit = $Background/MarginContainer/VBoxContainer/LineEdit
@onready var list: ItemList = $Background/MarginContainer/VBoxContainer/ItemList
@onready var btn_add: Button = $Background/MarginContainer/VBoxContainer/HBoxContainer/ButtonAdd
@onready var btn_cancel: Button	= $Background/MarginContainer/VBoxContainer/HBoxContainer/ButtonCancel
@onready var background: TextureRect = $Background
@onready var description: RichTextLabel = $Background/MarginContainer/VBoxContainer/RichTextLabel

# lated in _ready by scanning the components folder
var _all_components: Array[Dictionary] = []
var _component_by_index: Dictionary = {}

func _ready() -> void:
	var image = Image.create(1, 1, false, Image.FORMAT_RGBA8)
	image.fill(get_theme_color("base_color", "Editor"))
	background.texture = ImageTexture.create_from_image(image)
	_scan_components()
	search.text_changed.connect(_on_search_changed)
	btn_add.pressed.connect(_on_add_pressed)
	btn_cancel.pressed.connect(hide)
	close_requested.connect(hide)
	_populate_list("")


func _scan_components() -> void:
	_all_components.clear()
	var dir := DirAccess.open(COMPONENTS_ROOT)
	if not dir:
		push_error("RoseGarden: Could not open components folder at: " + COMPONENTS_ROOT)
		return
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if dir.current_is_dir() and not entry.begins_with("."):
			var scene_path := COMPONENTS_ROOT + entry + "/RG" + entry + ".tscn"
			var scene_path_array = (COMPONENTS_ROOT + entry + "/RG" + entry + ".tscn").split(" ")

			if ResourceLoader.exists(scene_path):
				_all_components.append({"name": _to_display_name(entry),"path": scene_path})
			else:
				push_warning("RoseGarden: Found folder '%s' but no matching .tscn at: %s" % [entry, scene_path])
		entry = dir.get_next()
	dir.list_dir_end()

	print("RoseGarden: Found %d components" % _all_components.size())


func _populate_list(filter: String) -> void:
	list.clear()
	_component_by_index.clear()
	for comp in _all_components:
		if filter.is_empty() or comp["name"].to_lower().contains(filter.to_lower()):
			_component_by_index[list.add_item(comp["name"])] = comp

func _to_display_name(folder_name: String) -> String:
	# "rg_text_field" → "RGTextField"
	var words: Array = Array(folder_name.split("_"))
	return words.map(func(w): return w.capitalize()) \
				.reduce(func(a, b): return a + b)

func _on_search_changed(text: String) -> void:
	_populate_list(text)
	if list.item_count > 0:
		list.select(0)

func _on_add_pressed() -> void:
	var selected := list.get_selected_items()
	if selected.is_empty():
		return
	var display_name: String = list.get_item_text(selected[0])
	var match := _all_components.filter(func(c): return c["name"] == display_name)
	if match.is_empty():
		return
	component_selected.emit(match[0]["path"])
	hide()


func _on_item_list_item_selected(index: int) -> void:
	var text:String
	var path:String = "res://addons/RoseGarden/components/"
	var path_split = _component_by_index[index]["name"].split(" ")
	for item in path_split:
		path += item
	path += "/description.txt"
	if !FileAccess.file_exists(path):
		description.visible = false
		return
	description.visible = true
	var file = FileAccess.open(path, FileAccess.READ)
	description.text = file.get_as_text()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
				KEY_ENTER, KEY_KP_ENTER:
					_on_add_pressed()
				KEY_ESCAPE:
					hide()

func _on_line_edit_text_submitted(new_text: String) -> void:
	list.select(0)
	_on_add_pressed()

func _input(event: InputEvent) -> void:
	if not visible:
		return
	if not (event is InputEventKey) or not event.pressed:
		return

	match event.keycode:
		KEY_UP, KEY_DOWN:
			# Hand focus and navigation to the list without leaving the search bar
			var current := list.get_selected_items()
			var next_idx: int

			if current.is_empty():
				next_idx = 0
			else:
				var current_idx: int = current[0]
				if event.keycode == KEY_DOWN:
					next_idx = min(current_idx + 1, list.item_count - 1)
				else:
					next_idx = max(current_idx - 1, 0)

			list.select(next_idx)
			list.ensure_current_is_visible()
			get_viewport().set_input_as_handled()

		KEY_ENTER, KEY_KP_ENTER:
			_on_add_pressed()
			get_viewport().set_input_as_handled()

		KEY_ESCAPE:
			hide()
			get_viewport().set_input_as_handled()
