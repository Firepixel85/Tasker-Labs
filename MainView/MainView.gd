extends Control

@onready var rcm_container: CanvasLayer = $RightClickMenuContainer
@onready var tooltip_container: CanvasLayer = $TooltipContainer
@onready var toast_layer: CanvasLayer = $ToastLayer
@onready var popup_container: CenterContainer = $PopupCanvasContainer/PopupContainer
@onready var popup_fade: TextureRect = $PopupCanvasContainer/PopupFade

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
	DisplayServer.window_set_min_size(Vector2i(1280, 960))
	Popups.popup_container = popup_container
	Popups.popup_fade = popup_fade
	Popups._ready()
	view_nodes["settings"] = settings_view
	view_nodes["plugins"] = plugins_view
	view_nodes["mainview"] = main_view
	if Settings.option_exists("core.general/display_name"):
		user_name.set_text(Settings.get_option_value("core.general/display_name"))
	Settings.setting_changed.connect(_settings_changed)
	RoseGarden.set_menu_layer(rcm_container)
	RoseGarden.set_tooltip_layer(tooltip_container)
	RoseGarden.set_toast_layer(toast_layer)
	CommandBar.load_commands()
	PluginManager._send_errors()

	#Add settings:

	#General
	if !Settings.category_exists("core.general"):
		Settings.add_category("General","res://Icons/User.svg","core.general")
	if !Settings.option_exists("core.general/display_name"):
		Settings.add_option("core.general","display_name","res://Settings/CoreOptions/General/DisplayName/CoreOption_DisplayName.tscn","Name")
	if !Settings.option_exists("core.general/update_notify"):
		Settings.add_option("core.general","update_notify","res://Settings/CoreOptions/General/UpdateNotify/CoreOption_UpdateNotify.tscn",true)
	if !Settings.option_exists("core.general/command_amount"):
		Settings.add_option("core.general","command_amount","res://Settings/CoreOptions/General/CommandAmount/CoreOption_CommandAmount.tscn",4)

	#Appearance
	if !Settings.category_exists("core.appearance"):
		Settings.add_category("Appearance","res://Icons/Palette.svg","core.appearance")
	if !Settings.option_exists("core.appearance/accent_color"):
		Settings.add_option("core.appearance","accent_color","res://Settings/CoreOptions/Appearance/AccentColor/CoreOption_AccentColor.tscn","Purple")
	if !Settings.option_exists("core.appearance/more_animations"):
		Settings.add_option("core.appearance","more_animations","res://Settings/CoreOptions/Appearance/MoreAnimations/CoreOption_MoreAnimations.tscn",false)

	#Accessibility
	if !Settings.category_exists("core.accessibility"):
		Settings.add_category("Accessibility","res://Icons/Person.svg","core.accessibility")
	if !Settings.option_exists("core.accessibility/disable_animations"):
		Settings.add_option("core.accessibility","disable_animations","res://Settings/CoreOptions/Accessibility/DisableAnimations/CoreOption_DisableAnimations.tscn",false)
	if !Settings.option_exists("core.accessibility/increase_contrast"):
		Settings.add_option("core.accessibility","increase_contrast","res://Settings/CoreOptions/Accessibility/IncreaseContrast/CoreOption_IncreaseContrast.tscn",false)
	if !Settings.option_exists("core.accessibility/symbol_indicators"):
		Settings.add_option("core.accessibility","symbol_indicators","res://Settings/CoreOptions/Accessibility/SymbolIndicators/CoreOption_SymbolIndicators.tscn",false)

	#Integrations
	if !Settings.category_exists("core.integrations"):
		Settings.add_category("Integrations","res://Icons/Blocks.svg","core.integrations")
	if !Settings.option_exists("core.integrations/integrations"):
		Settings.add_option("core.integrations","integrations","res://Settings/CoreOptions/Integrations/Integrations.tscn",0)

	#Developers
	if !Settings.category_exists("core.developer"):
		Settings.add_category("Developer","res://Icons/Code.svg","core.developer")
	if !Settings.option_exists("core.developer/dev_tools"):
		Settings.add_option("core.developer","dev_tools","res://Settings/CoreOptions/Developer/DevTools/CoreOption_DevTools.tscn",false)
	if !Settings.option_exists("core.developer/rg_options"):
		Settings.add_option("core.developer","rg_options","res://Settings/CoreOptions/Developer/RGOptions/CoreOption_RGOptions.tscn",false)
	if !Settings.option_exists("core.developer/reset_command_points"):
		Settings.add_option("core.developer","reset_command_points","res://Settings/CoreOptions/Developer/ResetCommandPoints/CoreOption_ResetCommandPoints.tscn",true)
	if !Settings.option_exists("core.developer/reset_window_size"):
		Settings.add_option("core.developer","reset_window_size","res://Settings/CoreOptions/Developer/ResetWindowSize/CoreOption_ResetWindowSize.tscn",true)

	#Rose Garden
	if !Settings.category_exists("core.rose_garden"):
		Settings.add_category("Rose Garden","res://Icons/RG.png","core.rose_garden")
	if !Settings.option_exists("core.rose_garden/button_press"):
		Settings.add_option("core.rose_garden","button_press","res://Settings/CoreOptions/RoseGarden/buttonPress/CoreOption_buttonPress.tscn",true)
	if !Settings.option_exists("core.rose_garden/toggle_press"):
		Settings.add_option("core.rose_garden","toggle_press","res://Settings/CoreOptions/RoseGarden/togglePress/CoreOption_togglePress.tscn",true)
	if !Settings.option_exists("core.rose_garden/sg_selection"):
		Settings.add_option("core.rose_garden","sg_selection","res://Settings/CoreOptions/RoseGarden/sgSelection/CoreOption_sgSelection.tscn",true)
	if !Settings.option_exists("core.rose_garden/sv_change"):
		Settings.add_option("core.rose_garden","sv_change","res://Settings/CoreOptions/RoseGarden/svChange/CoreOption_svChange.tscn",true)
	if !Settings.option_exists("core.rose_garden/rcm_selection"):
		Settings.add_option("core.rose_garden","rcm_selection","res://Settings/CoreOptions/RoseGarden/rcmSelection/CoreOption_rcmSelection.tscn",false)
	if !Settings.option_exists("core.rose_garden/rcm_appearance"):
		Settings.add_option("core.rose_garden","rcm_appearance","res://Settings/CoreOptions/RoseGarden/rcmAppearance/CoreOption_rcmAppearance.tscn",true)
	if !Settings.option_exists("core.rose_garden/ddm_appearance"):
		Settings.add_option("core.rose_garden","ddm_appearance","res://Settings/CoreOptions/RoseGarden/ddmAppearance/CoreOption_ddmAppearance.tscn",true)
	if !Settings.option_exists("core.rose_garden/ddm_selection"):
		Settings.add_option("core.rose_garden","ddm_selection","res://Settings/CoreOptions/RoseGarden/ddmSelection/CoreOption_ddmSelection.tscn",false)
	if !Settings.option_exists("core.rose_garden/toast_appearance"):
		Settings.add_option("core.rose_garden","toast_appearance","res://Settings/CoreOptions/RoseGarden/toastAppearance/CoreOption_toastAppearance.tscn",true)
	if !Settings.option_exists("core.rose_garden/tooltip_appearance"):
		Settings.add_option("core.rose_garden","tooltip_appearance","res://Settings/CoreOptions/RoseGarden/tooltipAppearance/CoreOption_tooltipAppearance.tscn",true)

	PluginManager._load_data()
	_update_setting_values()
	open_view("mainview")

func open_view(view_name:String):
	if !view_nodes.has(view_name):
		return ERR_DOES_NOT_EXIST
	if view_name == "settings":
		settings_view.setup()
	if view_name == "plugins":
		plugins_view.setup()
	view_nodes[view_name].modulate = Color(1,1,1,0)
	view_nodes[view_name].visible = true
	view_changed.emit(view_name)
	var tween = create_tween()
	tween.parallel().tween_property(view_nodes[view_name],"modulate",Color(1,1,1,1),0.15*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(view_nodes[_current_view],"modulate",Color(1,1,1,0),0.15*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	for key in view_nodes.keys():
		if key != view_name:
			view_nodes[key].visible = false
	_current_view = view_name
	return OK

func _process(_delta: float) -> void:
	if Popups.is_popup_active() and Input.is_action_just_pressed("view_close"):
		Popups.clear_popup()
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
	if option_path == "core.general/display_name":
		user_name.set_text(new_value)
	if option_path == "core.developer/dev_tools":
		for plugin_id in PluginManager.get_all_plugins():
			if PluginManager.is_plugin_loaded(plugin_id) and PluginManager.is_developer_plugin(plugin_id):
				PluginManager.unload_plugin(plugin_id)
	if option_path == "core.appearance/more_animations":
		RoseGarden.Animations.rcmSelection = new_value
		RoseGarden.Animations.ddmSelection = new_value
	if option_path == "core.rose_garden/button_press":
		RoseGarden.Animations.buttonPress = new_value
	if option_path == "core.rose_garden/toggle_press":
		RoseGarden.Animations.togglePress = new_value
	if option_path == "core.rose_garden/sg_selection":
		RoseGarden.Animations.sgSelection = new_value
	if option_path == "core.rose_garden/sv_change":
		RoseGarden.Animations.svChange = new_value
	if option_path == "core.rose_garden/rcm_selection":
		RoseGarden.Animations.rcmSelection = new_value
	if option_path == "core.rose_garden/rcm_appearance":
		RoseGarden.Animations.rcmAppearance = new_value
	if option_path == "core.rose_garden/ddm_appearance":
		RoseGarden.Animations.ddmAppearance = new_value
	if option_path == "core.rose_garden/ddm_selection":
		RoseGarden.Animations.ddmSelection = new_value
	if option_path == "core.rose_garden/toast_appearance":
		RoseGarden.Animations.toastAppearance = new_value
	if option_path == "core.rose_garden/tooltip_appearance":
		RoseGarden.Animations.tooltipAppearance = new_value
	if option_path == "core.developer/rg_options":
		if new_value:
			Settings.show_category("core.rose_garden")
		else:
			Settings.hide_category("core.rose_garden")


func _update_setting_values():
	if Settings.option_exists("core.general/display_name"):
		user_name.set_text(Settings.get_option_value("core.general/display_name"))
	RoseGarden.Animations.rcmSelection = Settings.get_option_value("core.appearance/more_animations")
	RoseGarden.Animations.ddmSelection = Settings.get_option_value("core.appearance/more_animations")
	if Settings.get_option_value("core.developer/rg_options"):
		Settings.show_category("core.rose_garden")
	else:
		Settings.hide_category("core.rose_garden")
	if Settings.is_category_shown("core.rose_garden"):
		RoseGarden.Animations.buttonPress = Settings.get_option_value("core.rose_garden/button_press")
		RoseGarden.Animations.togglePress = Settings.get_option_value("core.rose_garden/toggle_press")
		RoseGarden.Animations.sgSelection = Settings.get_option_value("core.rose_garden/sg_selection")
		RoseGarden.Animations.svChange = Settings.get_option_value("core.rose_garden/sv_change")
		RoseGarden.Animations.rcmSelection = Settings.get_option_value("core.rose_garden/rcm_selection")
		RoseGarden.Animations.rcmAppearance = Settings.get_option_value("core.rose_garden/rcm_appearance")
		RoseGarden.Animations.ddmAppearance = Settings.get_option_value("core.rose_garden/ddm_appearance")
		RoseGarden.Animations.ddmSelection = Settings.get_option_value("core.rose_garden/ddm_selection")
		RoseGarden.Animations.toastAppearance = Settings.get_option_value("core.rose_garden/toast_appearance")
		RoseGarden.Animations.tooltipAppearance = Settings.get_option_value("core.rose_garden/tooltip_appearance")
