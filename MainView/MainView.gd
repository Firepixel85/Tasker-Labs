extends Control

@onready var rcm_container: CanvasLayer = $RightClickMenuContainer
@onready var tooltip_container: CanvasLayer = $TooltipContainer
@onready var popup_container: CenterContainer = $PopupContainer
@onready var popup_fade: TextureRect = $PopupFade

#MainView
@onready var main_view: HBoxContainer = $MainView
@onready var user_name: RGText = $"MainView/Sidebar/Sidebar Bottom/VBoxContainer/Control Bar/MarginContainer/VBoxContainer/HBoxContainer/HBoxContainer/RGText"

#Settings
@onready var settings_view: HBoxContainer = $Settings

#Plugins
@onready var plugins_view: Control = $Plugins

const ID = "core.main_view"
var _current_view:String = ""
var view_nodes := {
	"":Control.new(), #Used for startup where no view is selected
	"mainview":null,
	"settings":null,
	"plugins":null
}
signal view_changed(new_view:String)

func _ready():
	Main.main_view = self
	Popups.popup_container = popup_container
	Popups.popup_fade = popup_fade
	Popups._ready()
	view_nodes["settings"] = settings_view
	view_nodes["plugins"] = plugins_view
	view_nodes["mainview"] = main_view
	if Settings.option_exists("core.preferences/display_name"):
		user_name.set_text(Settings.get_option_value("core.preferences/display_name"))
	Settings.setting_changed.connect(_settings_changed)
	RoseGarden.set_menu_layer(rcm_container)
	RoseGarden.set_tooltip_layer(tooltip_container)
	PluginManager._load_data()
	_update_setting_values()
	open_view("mainview")
	#Add settings:

	#Preferences
	if !Settings.category_exists("core.preferences"):
		Settings.add_category("Preferences","res://Icons/User.svg","core.preferences")
	if !Settings.option_exists("core.preferences/display_name"):
		Settings.add_option("core.preferences","display_name","res://Settings/CoreOptions/Preferences/DisplayName/CoreOption_DisplayName.tscn","Name")
	if !Settings.option_exists("core.preferences/update_notify"):
		Settings.add_option("core.preferences","update_notify","res://Settings/CoreOptions/Preferences/UpdateNotify/CoreOption_UpdateNotify.tscn",true)
	if !Settings.option_exists("core.preferences/more_animations"):
		Settings.add_option("core.preferences","more_animations","res://Settings/CoreOptions/Preferences/MoreAnimations/CoreOption_MoreAnimations.tscn",false)

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

func open_view(view_name:String):
	if !view_nodes.has(view_name):
		return ERR_ALREADY_EXISTS
	if view_name == "settings":
		settings_view.setup()
	view_nodes[view_name].modulate = Color(1,1,1,0)
	view_nodes[view_name].visible = true
	var tween = create_tween()
	tween.parallel().tween_property(view_nodes[view_name],"modulate",Color(1,1,1,1),0.15*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(view_nodes[_current_view],"modulate",Color(1,1,1,0),0.15*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	for key in view_nodes.keys():
		if key != view_name:
			view_nodes[key].visible = false
	view_changed.emit(view_name)
	_current_view = view_name

func _process(_delta: float) -> void:
	if Popups.is_popup_active() and Input.is_action_just_pressed("view_close"):
		Popups.remove_popup()
		RoseGarden._delete_all_menus()
		return
	elif Popups.is_popup_active():
		return
	if Input.is_action_just_pressed("settings_open") and !_current_view == "settings":
		open_view("settings")
		RoseGarden._delete_all_menus()
	if Input.is_action_just_pressed("plugin_open") and !_current_view == "plugins":
		open_view("plugins")
		RoseGarden._delete_all_menus()
	if Input.is_action_just_pressed("view_close") and !_current_view == "mainview":
		open_view("mainview")
		RoseGarden._delete_all_menus()

func _settings_changed(option_path,new_value):
	if option_path == "core.preferences/display_name":
		user_name.set_text(new_value)
	if option_path == "core.developer/dev_tools":
		for plugin_id in PluginManager.get_all_plugins():
			if PluginManager.is_plugin_loaded(plugin_id) and PluginManager.is_developer_plugin(plugin_id):
				PluginManager.unload_plugin(plugin_id)
	if option_path == "core.preferences/more_animations":
		RoseGarden.Animations.rcmSelection = new_value
		RoseGarden.Animations.ddmSelection = new_value

func _update_setting_values():
	user_name.set_text(Settings.get_option_value("core.preferences/display_name"))
	RoseGarden.Animations.rcmSelection = Settings.get_option_value("core.preferences/more_animations")
	RoseGarden.Animations.ddmSelection = Settings.get_option_value("core.preferences/more_animations")
