extends Node

var _client: Control

const ID = "core.sidebar"

@warning_ignore("unused_signal")
signal tab_selected(new_tab: String)


func add_tab(title: String, icon: Texture2D, scene: Resource, tab_id: String):
	if _client == null:
		(Debug . warn( ( "A process attempted to add a tab while the sidebar client was not ready, tab discarded. Tab ID: " + tab_id ), ID ))
		return ERR_BUSY
	return _client._add_tab(title, icon, scene, tab_id)


func remove_tab(tab_id: String):
	if _client == null:
		(Debug . warn( ( "A process attempted to remove a tab while the sidebar client was not ready, action discarded. Tab ID: " + tab_id ), ID ))
		return ERR_BUSY
	return _client._remove_tab(tab_id)


func select_tab(selection_id: String):
	if _client == null:
		(Debug . warn( ( "A process attempted to select a tab while the sidebar client was not ready, action discarded. Tab ID: " + selection_id ), ID ))
		return ERR_BUSY
	return _client._select(selection_id)


func get_selected_tab():
	if _client == null:
		(Debug . warn( "A process attempted to get the selected tab while the sidebar client was not ready, action discarded. Returning empty string.", ID ))
		return ""
	return _client.selected
