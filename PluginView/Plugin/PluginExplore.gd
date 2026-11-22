extends Control

@onready var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var display_name: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Name
@onready var version: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Version
@onready var developer_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/DeveloperTag
@onready var version_controlled_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionControlledTag
@onready var trusted_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TrustedTag

var id

func setup(new_id:String):
	id = new_id


func _on_install_pressed() -> void:
	pass # Replace with function body.
