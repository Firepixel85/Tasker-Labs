extends Control

@onready var hotkey_symbol: RGText = $HBoxContainer/MarginContainer/HotkeySymbol
@onready var hotkey_name: RGText = $HBoxContainer/HotkeyName
@onready var symbol_container: NinePatchRect = $SymbolContainer

func setup(hotkey_id):
	hotkey_name.set_text(HotkeyManager.get_hotkey_name(hotkey_id))
	hotkey_symbol.set_text(HotkeyManager.get_hotkey_symbol(hotkey_id))
	await get_tree().process_frame
	await get_tree().process_frame
	symbol_container.custom_minimum_size.x = hotkey_symbol.get_parent().size.x
