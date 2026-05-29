extends Node

var _client = null

func add_event(event_id:String,event_scene:Resource,event_icon:Texture2D):
	if _client == null:
		return ERR_BUSY
	return _client.add_event(event_id,event_scene,event_icon)

func remove_event(event_id:String):
	if _client == null:
		return ERR_BUSY
	return _client.remove_event(event_id)

func get_event_node(event_id:String):
	if _client == null:
		return ERR_BUSY
	return _client.get_event_node(event_id)

func event_exists(event_id:String):
	if _client == null:
		return ERR_BUSY
	return _client.event_exists(event_id)
