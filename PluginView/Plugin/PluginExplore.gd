extends Control

@onready var icon: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Icon
@onready var display_name: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Name
@onready var developer_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/DeveloperTag
@onready var version_controlled_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VersionControlledTag
@onready var trusted_tag: TextureRect = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/TrustedTag
@onready var description: Label = $RGContainer/MarginContainer/VBoxContainer/Description
@onready var info: Button = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer/Info
@onready var author: RGText = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Author
@onready var install: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer2/Install

var id

func setup(new_id:String):
	id = new_id
	display_name.set_text(StoreManager.get_plugin_name(id))
	description.set_text(StoreManager.get_plugin_description(id))
	author.set_text(StoreManager.get_plugin_author(id))
	if int(StoreManager.get_download_url(id)) == ERR_UNAVAILABLE:
		install.disabled = true
		install.text = "Unavailable"
		install.tooltip_display_text = "This plugin is incompatible with this version of Tasker."
	elif PluginManager.is_plugin_available(id):
		install.set_color("Gray",true)
		install.set_text("Uninstall")
		install.tooltip_display_text = "Uninstall "+StoreManager.get_plugin_name(id)+"."
	else:
		install.disabled = false
		install.text = "Install"
		install.tooltip_display_text = "Install "+StoreManager.get_plugin_name(id)+" from the store."


func _on_install_pressed() -> void:
	pass

func _on_info_mouse_entered() -> void:
	info.modulate = Color("ffffffff")

func _on_info_mouse_exited() -> void:
	info.modulate = Color("acacacff")

func _on_info_button_down() -> void:
	info.modulate = Color("ffffffaa")

func _on_info_button_up() -> void:
	info.modulate = Color("ffffffff")

func _on_info_pressed() -> void:
	pass # Replace with function body.


func _on_install_hovered() -> void:
	if PluginManager.is_plugin_available(id):
		install.set_color("Red")


func _on_install_de_hovered() -> void:
	if PluginManager.is_plugin_available(id):
		install.set_color("Gray")
