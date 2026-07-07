extends Button
@onready var main_view: Control = $"../../../../../../../../../.."

var keybinds := {"Settings": "⌘,", "Plugins": "⌘P"}
var view_keys := {"Settings": "settings_open", "Plugins": "plugin_open"}
var hovered := false


func _ready() -> void:
	mouse_entered.connect(_mouse_entered)
	mouse_exited.connect(_mouse_exited)


func _mouse_entered():
	modulate = RoseGarden.Colors.TEXT_MAIN
	hovered = true
	await get_tree().create_timer(1).timeout
	if !hovered or !keybinds.has(name):
		return
	var tooltip = RGTooltip.new()
	tooltip.set_text(name)
	tooltip.set_keybind(keybinds[name])
	tooltip.set_show_keybind(true)
	RoseGarden.create_tooltip(tooltip, get_global_mouse_position())


func _mouse_exited():
	modulate = RoseGarden.Colors.TEXT_SECONDARY
	hovered = false
	RoseGarden.clear_tooltips()


func _pressed() -> void:
	Input.action_press(view_keys[name])
	Input.action_release(view_keys[name])
