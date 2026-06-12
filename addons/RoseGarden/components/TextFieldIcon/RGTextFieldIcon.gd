@tool
extends Control
class_name RGTextFieldIcon
@onready var container: NinePatchRect = $NinePatchRect
@onready var line_edit: LineEdit = $MarginContainer/LineEdit
@onready var hint_text: Label = $MarginContainer2/VBoxContainer/HBoxContainer/NinePatchRect/MarginContainer/Label
@onready var hint_texture: NinePatchRect = $MarginContainer2/VBoxContainer/HBoxContainer/NinePatchRect
@onready var hint_container: MarginContainer = $MarginContainer2
@onready var icon_holder: TextureRect = $MarginContainer3/HBoxContainer/TextureRect

@export var placeholder_text:String = ""
@export var icon:Texture2D
@export var editable:bool = true
@export var appear_uneditable:bool = true
@export var emoji_menu_enabled:bool = true
@export var caret_blink:bool = true
@export var show_hint:bool = false
@export var hint := "⌘K"
@export var context_menu:bool = true
@export var secret := false
@export var incorrect:bool = false
@export var needs_focus:bool = true##Will this component close when it loses focus

var text:String
signal text_changed(new_text:String)
signal text_submitted(new_text:String)

func get_text():
	return line_edit.text

func set_text(new_text:String):
	line_edit.text = new_text
	_update()
	text_changed.emit(new_text)
	return OK

func set_icon(new_icon:Texture2D):
	icon = new_icon
	_update()
	return OK

func get_icon():
	return icon

func set_hint(new_hint:String):
	hint = new_hint
	_update()
	return OK

func set_inccorrect(is_incorrect:bool):
	incorrect = is_incorrect
	_update()
	return OK

func edit():
	line_edit.grab_focus()
	line_edit.edit()
	return OK

func exit():
	line_edit.release_focus()
	_update()

func cut():
	if !line_edit.has_selection():
		return ERR_DOES_NOT_EXIST
	DisplayServer.clipboard_set(line_edit.get_selected_text())
	var new_text_before_selection = line_edit.get_selected_text().substr(0, line_edit.get_selection_from_column())
	var new_text_after_selection = line_edit.get_selected_text().substr(line_edit.get_selection_to_column())
	line_edit.text = new_text_before_selection + new_text_after_selection
	line_edit.set_caret_column(line_edit.get_selection_from_column())
	line_edit.deselect()
	return OK

func copy():
	DisplayServer.clipboard_set(get_text())
	line_edit.select_all()
	line_edit.set_caret_column(line_edit.get_selection_to_column())
	line_edit.deselect()
	return OK

func paste():
	set_text(get_text()+DisplayServer.clipboard_get())
	line_edit.select_all()
	line_edit.set_caret_column(line_edit.get_selection_to_column())
	line_edit.deselect()
	return OK

##############
#### STOP #### Here begin private functions that should never be called by your code
##############

func _update():
	if incorrect:
		line_edit.modulate = RoseGarden.Colors.RED_HIGHLIGHT
		container.texture = load(RoseGarden._get_file_path()+"TextField/ContainerIncorrect.svg")
		icon_holder.modulate = RoseGarden.Colors.RED_HIGHLIGHT
	else:
		line_edit.modulate = Color(1,1,1)
		container.texture = load(RoseGarden._get_file_path()+"TextField/Container.svg")
		if line_edit.has_focus():
			icon_holder.modulate = Color(1,1,1)
		else:
			icon_holder.modulate = RoseGarden.Colors.TEXT_SECONDARY

	hint_texture.texture = load(RoseGarden._get_file_path()+"TextFieldIcon/Keybind Container.svg")
	hint_text.text = hint
	container.size.x = size.x
	hint_container.size.x = size.x
	line_edit.get_parent().size.x = size.x
	hint_texture.custom_minimum_size.x = hint_text.size.x + 16
	icon_holder.texture = icon

	if line_edit.has_focus():
		create_tween().tween_property(hint_container,"modulate",Color(0,0,0,0),0.1*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_BOUNCE)
		icon_holder.modulate = Color(1,1,1)
	elif needs_focus:
		create_tween().tween_property(hint_container,"modulate",Color(1,1,1,1),0.1*int(!RoseGarden.Accessibility.get_disable_animations())).set_trans(Tween.TRANS_BOUNCE)
		icon_holder.modulate = RoseGarden.Colors.TEXT_SECONDARY

	if show_hint:
		hint_container.visible = true
	else:
		hint_container.visible = false

	if secret and line_edit.text != "":
		line_edit.get_parent().size.y = 74
	else:
		line_edit.get_parent().size.y = 60

	if appear_uneditable:
		line_edit.add_theme_color_override("font_uneditable_color",Color("dfdfdf80"))
	else:
		line_edit.add_theme_color_override("font_uneditable_color",Color("f5f5f5"))

	_mirror_to_line_edit()
	line_edit.caret_blink = !RoseGarden.Accessibility.get_disable_animations()


func _process(_delta: float) -> void:
	if secret:
		if get_text() == "":
			line_edit.add_theme_font_size_override("font_size",20)
		else:
			line_edit.add_theme_font_size_override("font_size",30)
	else:
		line_edit.add_theme_font_size_override("font_size",20)
	if Engine.is_editor_hint():
		_update()

func _ready() -> void:
	RoseGarden.custom_themes_changed.connect(_update_themes)
	RoseGarden.custom_textures_changed.connect(_update)
	_update_themes()
	_update()
	await get_tree().create_timer(0.2).timeout
	_update()

func _on_text_changed(_new_text: String) -> void:
	_update()
	text_changed.emit(_new_text)

func _on_focus_exited() -> void:
	_update()

func _mirror_to_line_edit():
	line_edit.placeholder_text = placeholder_text
	line_edit.editable = editable
	line_edit.emoji_menu_enabled = emoji_menu_enabled
	line_edit.caret_blink = caret_blink
	line_edit.secret = secret

func _on_mouse_entered() -> void:
	modulate = RoseGarden.Colors.COLOR_HOVERED

func _on_mouse_exited() -> void:
	modulate = RoseGarden.Colors.COLOR_NORMAL

func clear():
	line_edit.clear()
	_update()

func _on_line_edit_text_submitted(new_text: String) -> void:
	text_submitted.emit(new_text)

func _update_themes():
	line_edit.theme = RoseGarden.Themes.Secondary
	hint_text.theme = RoseGarden.Themes.Secondary


func _on_line_edit_focus_entered() -> void:
	focus_entered.emit()

func _on_line_edit_focus_exited() -> void:
	focus_exited.emit()


func _on_gui_input(event: InputEvent) -> void:
	if !context_menu:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MASK_RIGHT and event.pressed:
		line_edit.deselect_on_focus_loss_enabled = false
		var menu = RGmenu.new()
		menu.add_action("Cut",Icons.SCISSORS,cut)
		menu.add_action("Copy",Icons.COPY,copy)
		menu.add_action("Paste",Icons.CLIPBOARD,paste)
		menu.add_seperator()
		menu.add_action("Select All",Icons.TEXTCURSOR,line_edit.select_all)
		menu.add_action("Clear",Icons.X,line_edit.clear)
		menu.add_seperator()
		menu.add_action("Undo",Icons.UNDO,line_edit.menu_option,[line_edit.MENU_UNDO])
		menu.add_action("Redo",Icons.REDO,line_edit.menu_option,[line_edit.MENU_REDO])
		RoseGarden.create_rc_menu(menu,get_global_mouse_position())
		await RoseGarden.rcm_closed
		line_edit.edit()
		await get_tree().process_frame
		line_edit.deselect_on_focus_loss_enabled = true
