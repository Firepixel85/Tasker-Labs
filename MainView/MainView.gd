extends Control

@onready var rcm_container: CanvasLayer = $RightClickMenuContainer

#MainView
@onready var mainview_screen: HBoxContainer = $MainView
@onready var user_name: RGText = $"MainView/Sidebar/Sidebar Bottom/VBoxContainer/Control Bar/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/RGText"

#Settings
@onready var settings_screen: HBoxContainer = $Settings

#Plugins
@onready var plugins: Control = $Plugins

var _current_view:String = "mainview"
var view_nodes := {
	"mainview":self,
	"settings":settings_screen,
	"plugins":plugins
}
signal view_changed(new_view:String)

func _ready():
	Main.main_view = self
	if Settings.option_exists("core.preferences/display_name"):
		user_name.set_text(Settings.get_option_value("core.preferences/display_name"))
	Settings.setting_changed.connect(_settings_changed)
	RoseGarden.menu_layer = rcm_container
	PluginManager._load_data()
	open_mainview()
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

	#Accessibility
	if !Settings.category_exists("core.accessibility"):
		Settings.add_category("Accessibility","res://Icons/Person.svg","core.accessibility")
	if !Settings.option_exists("core.accessibility/disable_animations"):
		Settings.add_option("core.accessibility","disable_animations","res://Settings/CoreOptions/Accessibility/DisableAnimations/CoreOption_DisableAnimations.tscn",false)
	if !Settings.option_exists("core.accessibility/increase_contrast"):
		Settings.add_option("core.accessibility","increase_contrast","res://Settings/CoreOptions/Accessibility/IncreaseContrast/CoreOption_IncreaseContrast.tscn",false)
	if !Settings.option_exists("core.accessibility/symbol_indicators"):
		Settings.add_option("core.accessibility","symbol_indicators","res://Settings/CoreOptions/Accessibility/SymbolIndicators/CoreOption_SymbolIndicators.tscn",false)

	#Developers
	if !Settings.category_exists("core.developer"):
		Settings.add_category("Developer","res://Icons/Code.svg","core.developer")
	if !Settings.option_exists("core.developer/dev_tools"):
		Settings.add_option("core.developer","dev_tools","res://Settings/CoreOptions/Developer/DevTools/CoreOption_DevTools.tscn",true)


func open_settings() -> void:
	_current_view = "settings"
	view_changed.emit("settings")
	settings_screen.visible = true
	mainview_screen.visible = false
	plugins.visible = false
	settings_screen.setup()

func open_mainview():
	_current_view = "mainview"
	view_changed.emit("mainview")
	mainview_screen.visible = true
	settings_screen.visible = false
	plugins.visible = false

func open_plugins() -> void:
	_current_view = "plugins"
	view_changed.emit("plugins")
	plugins.visible = true
	mainview_screen.visible = false
	settings_screen.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("settings_open") and !_current_view == "settings":
		open_settings()
	if Input.is_action_just_pressed("plugin_open") and !_current_view == "plugins":
		open_plugins()
	if Input.is_action_just_pressed("view_close") and !_current_view == "mainview":
		open_mainview()

func _settings_changed(option_path,new_value):
	if option_path == "core.preferences/display_name":
		user_name.set_text(new_value)
	if option_path == "core.developer/dev_tools":
		Main.developerMode = new_value
		for plugin_id in PluginManager.get_all_plugins():
			if PluginManager.is_plugin_loaded(plugin_id) and PluginManager.is_developer_plugin(plugin_id):
				PluginManager.unload_plugin(plugin_id)
		print(Main.developerMode)
