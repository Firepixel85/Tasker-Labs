extends Control
@onready var rcm_container: CanvasLayer = $RightClickMenuContainer
@onready var settings_screen: HBoxContainer = $Settings
@onready var mainview_screen: HBoxContainer = $MainView
@onready var user_name: RGText = $"MainView/Sidebar/Sidebar Bottom/VBoxContainer/Control Bar/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/RGText"

var settings_open:bool = false
func _ready():
	user_name.set_text(Settings.get_option_value("core.preferences/display_name"))
	Settings.setting_changed.connect(_settings_changed)
	RoseGarden.menu_layer = rcm_container
	if Main.developerMode:
		PluginManager.load_plugin("com.rosepen.console")

	#Add settings:

	#Preferences
	if !Settings.category_exists("core.preferences"):
		Settings.add_category("Preferences","res://Icons/User.svg","core.preferences")
	if !Settings.option_exists("core.preferences/display_name"):
		Settings.add_option("core.preferences","display_name","res://Settings/CoreOptions/Preferences/DisplayName/CoreOption_DisplayName.tscn","Name")
	if !Settings.option_exists("core.preferences/update_notify"):
		Settings.add_option("core.preferences","update_notify","res://Settings/CoreOptions/Preferences/UpdateNotify/CoreOption_UpdateNotify.tscn",true)
	if !Settings.option_exists("core.preferences/animate_sidebar"):
		Settings.add_option("core.preferences","animate_sidebar","res://Settings/CoreOptions/Preferences/AnimateSidebar/CoreOption_AnimateSidebar.tscn",false)

	#Appearance
	if !Settings.category_exists("core.appearance"):
		Settings.add_category("Appearance","res://Icons/Palette.svg","core.appearance")
	if !Settings.option_exists("core.appearance/accent_color"):
		Settings.add_option("core.appearance","accent_color","res://Settings/CoreOptions/Appearance/AccentColor/CoreOption_AccentColor.tscn","Purple")



func _on_settings_pressed() -> void:
	settings_open = true
	mainview_screen.visible = false
	settings_screen.visible = true
	settings_screen.setup()


func _on_close_button_pressed() -> void:
	pass # Replace with function body.

func close_settings():
	settings_open = false
	mainview_screen.visible = true
	settings_screen.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("settings_open") and !settings_open:
		_on_settings_pressed()
	if Input.is_action_just_pressed("settings_close") and settings_open:
		close_settings()


func _settings_changed(option_path,new_value):
	if option_path == "core.preferences/display_name":
		user_name.set_text(new_value)
