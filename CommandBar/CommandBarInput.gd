@tool
extends RGTextFieldIcon
@onready var command_bar: Control = $"../../../../../CommandBar/CommandBar"
@onready var main_view: Control = $"../../../../.."

func _process(_delta: float) -> void:
	if Engine.is_editor_hint() or Main.get_current_view() != "mainview":
		return
	if Input.is_action_just_pressed("command_bar_open") and !command_bar.visible:
		open()
	if Input.is_action_just_pressed("view_close") and command_bar.visible:
		close()
	super._process(_delta)

func _on_line_edit_text_submitted(new_text: String) -> void:
	close(true)
	super._on_line_edit_text_submitted(new_text)

func _on_line_edit_focus_entered() -> void:
	if command_bar.is_open():
		return
	open()
	super._on_line_edit_focus_entered()

func _on_text_changed(_new_text: String) -> void:
	command_bar.update_shown_commands()

func _on_line_edit_focus_exited() -> void:
	await get_tree().process_frame
	if await !command_bar.command_has_focus():
		close()
	super._on_line_edit_focus_exited()

func open():
	command_bar.open()
	edit()

func close(execute:=false):
	if execute:
		command_bar.execute_command(command_bar.get_selected())
	command_bar.close()
	set_text("")
	exit()

func _ready():
	command_bar.input = self
	main_view.view_changed.connect(_close)
	super._ready()

func _close(_value):
	close()
