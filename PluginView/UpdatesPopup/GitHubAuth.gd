extends Control

@onready var auth: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Auth

func _on_pp_meta_clicked(_meta: Variant) -> void:
	OS.shell_open("https://taskerapp.framer.website/privacy-pledge")

func _on_account_meta_clicked(_meta: Variant) -> void:
	OS.shell_open("https://github.com/signup")

func _authorize():
	if Network.GitHubAuth.is_authorized():
		RoseGarden.create_toast("Account already connected","Blue")
		Popups.remove_popup()
		return
	Network.auth_completed.connect(_success)
	Network.auth_failed.connect(_fail)
	Network.GitHubAuth.authorize()
	auth.disabled = true
	auth.set_text("Redirecting...")

func _success(_reason:String):
	Popups.remove_popup()
	await Popups.popup_removed
	Popups.add_popup(load("res://PluginView/UpdatesPopup/AuthSuccess.tscn"))

func _fail(_reason:String):
	Popups.remove_popup()
	await Popups.popup_removed
	Popups.add_popup(load("res://PluginView/UpdatesPopup/AuthFailed.tscn"))

func _on_close_pressed() -> void:
	Popups.remove_popup()

func _ready() -> void:
	get_child(0)._update()
