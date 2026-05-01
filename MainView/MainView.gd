extends Control
@onready var rcm_container: CanvasLayer = $RightClickMenuContainer
@onready var settings_screen: HBoxContainer = $Settings
@onready var mainview_screen: HBoxContainer = $MainView

func _ready():
	RoseGarden.menu_layer = rcm_container
	if Main.developerMode:
		PluginManager.load_plugin("com.rosepen.console")
	#Settings.add_category("Preferences","res://Icons/User.svg","core.preferences")
	#Settings.add_category("Test","res://Icons/User.svg","core.test")


func _on_settings_pressed() -> void:
	mainview_screen.visible = false
	settings_screen.visible = true
	settings_screen.setup()


func _on_close_button_pressed() -> void:
	pass # Replace with function body.

func close_settings():
	mainview_screen.visible = true
	settings_screen.visible = false
