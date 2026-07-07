extends Node

var _client = null
const ID = "core.event_manager"


func add_event(event_id: String, event_scene: Resource, event_icon: Texture2D):
	if _client == null:
		Debug.warn("A process attempted to add an event while the event client was not ready, event discarded. Event ID: " + event_id, ID )
		return ERR_BUSY
	return _client.add_event(event_id, event_scene, event_icon)


func remove_event(event_id: String):
	if _client == null:
		Debug.warn("A process attempted to remove an event while the event client was not ready, action discarded. Event ID: " + event_id, ID )
		return ERR_BUSY
	return _client.remove_event(event_id)


func get_event_node(event_id: String):
	if _client == null:
		Debug.warn("A process attempted to get the node of an event while the event client was not ready, action discarded. Event ID: " + event_id, ID )
		return ERR_BUSY
	return _client.get_event_node(event_id)


func event_exists(event_id: String):
	if _client == null:
		Debug.warn("A process attempted to check if an event exists while the event client was not ready, action discarded. Event ID: " + event_id, ID )
		return ERR_BUSY
	return _client.event_exists(event_id)
