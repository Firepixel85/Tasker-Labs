extends Control

@onready var refresh_button: RGButton = $ActionContainer/MarginContainer/HBoxContainer/Refresh
@onready var folder_button: RGButton = $ActionContainer/MarginContainer/HBoxContainer/Folder
@onready var action_container: Control = $ActionContainer

func _on_rg_button_pressed() -> void:
	Input.action_press("view_close")
	Input.action_release("view_close")
	OS.shell_open("https://github.com/Firepixel85/Tasker-Labs/blob/main/DeveloperPluginGuide.md")

func _on_folder_pressed() -> void:
	OS.shell_show_in_file_manager(OS.get_user_data_dir()+"/plugins")


func _on_refresh_hovered() -> void:
	await get_tree().create_timer(1).timeout
	if refresh_button.is_hovered():
		var tooltip = RGTooltip.new()
		tooltip.set_text("Refresh shown plugins")
		tooltip.set_keybind("⌘⇧R")
		RoseGarden.create_tooltip(tooltip, get_global_mouse_position())

func _on_folder_hovered() -> void:
	await get_tree().create_timer(1).timeout
	if folder_button.is_hovered():
		var tooltip = RGTooltip.new()
		tooltip.set_text("Open plugins folder")
		tooltip.set_keybind("⌘⇧O")
		RoseGarden.create_tooltip(tooltip, get_global_mouse_position())

func _clear_tooltips() -> void:
	RoseGarden.clear_tooltips()

func _on_refresh_pressed():
	get_parent().get_child(1).refresh() #Refreshes through InstalledView to populate the plugin lists correctly if a plugin is found

func _ready() -> void:
	action_container.custom_minimum_size.x = action_container.get_child(1).get_minimum_size().x
	action_container._update()
