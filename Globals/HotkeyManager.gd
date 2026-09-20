extends Node

const ID:String = "core.hotkey_manager"

var hotkeys:Dictionary = {}

func register_hotkey(hotkey_name:String,symbol:String,event:InputEventKey,keywords:=[],tab_specific_id:=""):
	if hotkeys.has(hotkey_name):
		Debug.log("A process tried to register a hotkey that already exists: %s" % hotkey_name,ID)
		return ERR_ALREADY_EXISTS
	var hotkey_id:String = hotkey_name.to_lower().replace(" ","_")
	hotkeys[hotkey_id] = {
		"name": hotkey_name,
		"symbol": symbol,
		"event": event,
		"keywords": keywords,
		"tab_specific_id": tab_specific_id
	}
	if event == null:
		Debug.log("Registered hotkey without event: %s" % hotkey_id,ID)
		return hotkey_id
	if not InputMap.has_action(hotkey_id):
		InputMap.add_action(hotkey_id)
	InputMap.action_add_event(hotkey_id, event)
	Debug.log("Registered hotkey: %s" % hotkey_id,ID)
	return hotkey_id

func unregister_hotkey(hotkey_id:String):
	if not hotkeys.has(hotkey_id):
		Debug.log("A process tried to unregister a hotkey that doesn't exist: %s" % hotkey_id,ID)
		return ERR_DOES_NOT_EXIST
	hotkeys.erase(hotkey_id)
	if hotkeys[hotkey_id]["event"] == null:
		return OK
	if InputMap.has_action(hotkey_id):
		InputMap.erase_action(hotkey_id)
	return OK

func get_hotkey_name(hotkey_id:String) -> String:
	if not hotkeys.has(hotkey_id):
		Debug.log("A process tried to get the name of a hotkey that doesn't exist: %s" % hotkey_id,ID)
		return ""
	return hotkeys[hotkey_id]["name"]

func get_hotkey_symbol(hotkey_id:String) -> String:
	if not hotkeys.has(hotkey_id):
		Debug.log("A process tried to get the symbol of a hotkey that doesn't exist: %s" % hotkey_id,ID)
		return ""
	return hotkeys[hotkey_id]["symbol"]

func get_hotkey_keywords(hotkey_id:String) -> Array:
	if not hotkeys.has(hotkey_id):
		Debug.log("A process tried to get the keywords of a hotkey that doesn't exist: %s" % hotkey_id,ID)
		return []
	return hotkeys[hotkey_id]["keywords"]

func get_tab_specific_id(hotkey_id:String) -> String:
	if not hotkeys.has(hotkey_id):
		Debug.log("A process tried to get the tab specific id of a hotkey that doesn't exist: %s" % hotkey_id,ID)
		return ""
	return hotkeys[hotkey_id]["tab_specific_id"]
