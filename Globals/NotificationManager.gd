extends Node

var _client = null

func queue_notification(title:String,description:String,is_error:=false,action=null,action_params:=[],duration:=4.0):
	if _client == null:
		return ERR_BUSY
	return _client.queue_notification(title,description,is_error,action,action_params,duration)
