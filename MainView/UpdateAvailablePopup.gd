extends Control

@onready var version_name: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionName
@onready var release_date: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/ReleaseDate
@onready var size_text: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer2/Size
@onready var description: RichTextLabel = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/Description

func _on_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
