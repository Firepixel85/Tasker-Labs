extends Node

var _client = null
const ID = "core.notification_manager"


func queue_notification(
	title: String,
	description: String,
	is_error := false,
	action = null,
	action_params := [],
	duration := 4.0
):
	if _client == null:
		Debug.warn("A process attempted to queue a notification while the notification client was not ready, notification discarded. Title: " + title, ID )
		return ERR_BUSY
	return _client.queue_notification(title, description, is_error, action, action_params, duration)
