extends Control

@onready var action: RGButton = $HBoxContainer/Action
@onready var status: RGText = $HBoxContainer/StatusContainer/CenterContainer/Status
@onready var status_container: Control = $HBoxContainer/StatusContainer


signal value_changed(option_id,new_value)

func set_value(_value:int):
	pass

func get_value():
	return 0

func interact():
	action.press()

func _ready() -> void:
	if Network.GitHubAuth.is_authorized():
		status.text = "Connected"
		status.custom_color = Color(RoseGarden.Colors.GREEN_HIGHLIGHT)
		action.text = "Disconnect"
	else:
		status.custom_color = Color(RoseGarden.Colors.RED_HIGHLIGHT)
		status.text = "Not connected"
		action.text = "Connect"
	status_container.size.x = status.get_minimum_size().x
	status_container._update()
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
