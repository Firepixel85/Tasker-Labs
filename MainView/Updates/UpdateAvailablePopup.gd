extends Control

@onready var version_name: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionName
@onready var release_date: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/ReleaseDate
@onready var size_text: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Size
@onready var description: RichTextLabel = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Description
@onready var update_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Update

func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))

func _ready() -> void:
	update_button.set_color(Settings.get_option_value("core.appearance/accent_color"))

func _on_cancel_pressed() -> void:
	Popups.clear_popup()

func _on_update_pressed() -> void:
	Network.Updates.update()
