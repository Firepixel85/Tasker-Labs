extends Control

@onready var app_version: RGText = $"VBoxContainer/HBoxContainer/App Version"
@onready var build_id: RGText = $"VBoxContainer/HBoxContainer2/Build ID"
@onready var api_version: RGText = $"VBoxContainer/HBoxContainer3/API Version"
@onready var available_plugins: RGText = $"VBoxContainer/HBoxContainer4/Available Plugins"
@onready var loaded_plugins: RGText = $"VBoxContainer/HBoxContainer5/Loaded plugins"

@onready var options: VBoxContainer = $VBoxContainer
@onready var love_letter: TextureRect = $TextureRect
@onready var close_ll_container: VBoxContainer = $VBoxContainer2

func _ready() -> void:
	app_version.set_text(Main.get_version())
	build_id.set_text(Main.get_version()+Main.get_version_sufix())
	api_version.set_text(Main.get_plugin_api_version())
	available_plugins.set_text(str((PluginManager.get_all_plugins().size())))
	loaded_plugins.set_text(str(PluginManager._loaded_plugins.size()))

func _on_open_user_folder_pressed() -> void:
	OS.shell_show_in_file_manager(OS.get_user_data_dir())

func _on_open_love_letter_pressed():
	options.visible = false
	love_letter.visible = true
	close_ll_container.visible = true


func _on_close_ll_pressed() -> void:
	options.visible = true
	love_letter.visible = false
	close_ll_container.visible = false
