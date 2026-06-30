extends MarginContainer

@onready var action: RGButton = $VBoxContainer/HBoxContainer2/Action
@onready var status: RGText = $VBoxContainer/HBoxContainer/StatusContainer/MarginContainer/Status
@onready var status_container: NinePatchRect = $VBoxContainer/HBoxContainer/StatusContainer

func _ready() -> void:
	if Network.GitHubAuth.is_authorized():
		status.text = "Connected"
		status.custom_color = Color(RoseGarden.Colors.GREEN_HIGHLIGHT)
		action.text = "Disconnect"
	else:
		status.custom_color = Color(RoseGarden.Colors.RED_HIGHLIGHT)
		status.text = "Not connected"
		action.text = "Connect"
	await status._update()
	status_container.custom_minimum_size.x = status.get_parent().get_minimum_size().x
	status.position = Vector2(0,0)
	status._update()

func _on_action_hovered() -> void:
	if Network.GitHubAuth.is_authorized():
		action.set_color("Red")
	else:
		action.set_color(Settings.get_option_value("core.appearance/accent_color"))

func _on_action_de_hovered() -> void:
	action.set_color("Gray")

func _on_action_pressed() -> void:
	if Network.GitHubAuth.is_authorized():
		var err = Network.GitHubAuth.disconnect_auth()
		if err != OK:
			RoseGarden.create_toast("Failed to disconnect account","Red")
		else:
			RoseGarden.create_toast("Account disconnected","Green")
			action.set_color("Gray")
	else:
		Popups.add_popup(load("res://PluginView/UpdatesPopup/GitHubAuth.tscn"))
		await Network.auth_completed
	_ready()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("1") and Input.is_key_pressed(KEY_SHIFT):
		action.press()
