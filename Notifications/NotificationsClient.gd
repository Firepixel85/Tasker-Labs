extends Control

const ID = "core.notification_manager"
var _queue := []
var _playing_queue:bool = false

func _ready() -> void:
	NotificationManager._client = self

func queue_notification(title:String,description:String,is_error:=false,action=null,action_params:=[],duration:=4.0):
	_queue.append([title,description,is_error,action,action_params,duration])
	if !_playing_queue:
		_playing_queue = true
		_play_queue()
	Debug.log("Notification added to queue",ID)
	return OK
	
func _play_queue():
	while _queue.size() != 0:
		get_parent().show()
		var notification_node:Notification
		add_child(preload("res://Notifications/Notification.tscn").instantiate())
		notification_node = get_child(get_child_count()-1)
		notification_node.setup(_queue[0][0],_queue[0][1],_queue[0][2],_queue[0][3],_queue[0][4],_queue[0][5])
		_queue.remove_at(0)
		print(notification_node.size.y)
		notification_node.position.y = size.y - notification_node.size.y
		Debug.log("Notification queue advanced, items remaining: "+str(_queue.size()),ID)
		await notification_node.closed
		notification_node.queue_free()
	_playing_queue = false
	get_parent().hide()
