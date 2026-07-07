extends Control

@onready var auth: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Auth


func _on_pp_meta_clicked(_meta: Variant) -> void:
	OS.shell_open("https://taskerapp.framer.website/privacy-pledge")


func _on_account_meta_clicked(_meta: Variant) -> void:
	OS.shell_open("https://github.com/signup")


func _authorize():
	if Network.GitHubAuth.is_authorized():
		RoseGarden.create_toast("Account already connected", "Blue")
		Popups.clear_popup()
		return
	Network.auth_completed.connect(_success)
	Network.auth_failed.connect(_fail)
	Network.GitHubAuth.authorize()
	auth.disabled = true
	auth.set_text("Redirecting...")


func _success(_reason: String):
	Popups.clear_popup()
	await Popups.popup_cleared
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.NO_ACTION)
	popup.set_title("Account Connected!")
	(
		popup
		. set_description(
			"Your account was connected successfuly! You can disconnect it at any time from Settings>Integrations."
		)
	)
	Popups.create_prefab_popup(popup)


func _fail(_reason: String):
	Popups.clear_popup()
	await Popups.popup_cleared
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.SINGLE_ACTION)
	popup.set_title("Connection Failed!")
	(
		popup
		. set_description(
			"An error ocurred during account connection.  You can retry to connect your account with the button below:"
		)
	)
	popup.add_action(
		Popups.add_popup, "Retry", [load("res://PluginView/UpdatesPopup/GitHubAuth.tscn")]
	)
	popup.add_action_name("Retry")
	popup.add_color("White")
	Popups.create_prefab_popup(popup)


func _on_close_pressed() -> void:
	Popups.clear_popup()


func _ready() -> void:
	get_child(0)._update()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_confirm"):
		auth.press()
