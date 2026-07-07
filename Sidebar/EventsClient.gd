extends ScrollContainer

@onready var container: HBoxContainer = $"Event Container"
@onready var selection: RGSegmentControlIcon = $"../EventSelection"

const ID = "core.event_manager"
var events: Dictionary = {}
var event_icons: Dictionary = {}
var event_nodes: Dictionary = {}


func add_event(event_id: String, event_scene: Resource, event_icon: Texture2D):
	if events.has(event_id):
		Debug.warn(( "Process: " + Main.get_process_name(event_id) + " attempted to add an event with an id that already exists: " + event_id ), ID)
		return ERR_ALREADY_EXISTS
	if !event_scene is PackedScene:
		(Debug . warn( ( "Process: " + Main.get_process_name(event_id) + " attempted to add an event with a scene that is not a PackedScene, event discarded. Event ID: " + event_id ), ID ))
		return ERR_INVALID_PARAMETER
	events[event_id] = event_scene
	event_icons[event_id] = event_icon
	container.add_child(event_scene.instantiate())
	event_nodes[event_id] = container.get_child(container.get_child_count() - 1)
	event_nodes[event_id].custom_minimum_size = Vector2(448, 168)
	selection.add_item(event_id, event_icon)
	_update()
	Debug.log("Event added by process: " + Main.get_process_name(event_id), ID)
	return OK


func remove_event(event_id: String):
	if !events.has(event_id):
		Debug.warn(( "Process: " + Main.get_process_name(event_id) + " attempted to remove an event with an id that does not exist: " + event_id ), ID)
		return ERR_DOES_NOT_EXIST
	events.erase(event_id)
	event_icons.erase(event_id)
	event_nodes[event_id].queue_free()
	event_nodes.erase(event_id)
	selection.remove_item(event_id)
	_update()
	Debug.log("Event removed by process: " + Main.get_process_name(event_id), ID)
	return OK


func get_event_node(event_id: String):
	if !events.has(event_id):
		Debug.warn(( "Process: " + Main.get_process_name(event_id) + " attempted to get the node of an event with an id that does not exist: " + event_id ), ID)
		return ERR_DOES_NOT_EXIST
	return event_nodes[event_id]


func event_exists(event_id: String):
	return events.has(event_id)


func _ready() -> void:
	EventManager._client = self


func _update():
	if events.size() == 0:
		visible = false
		selection.visible = false
	elif events.size() == 1:
		visible = true
		selection.visible = false
	else:
		selection.visible = true


func _on_event_selected(item_name: String) -> void:
	(
		create_tween()
		. tween_property(
			self,
			"scroll_horizontal",
			event_nodes[item_name].position.x,
			0.2 * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_IN_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)


func _process(_delta: float) -> void:
	if Main.get_current_view() != "mainview":
		return

	if Input.is_action_just_pressed("event_next") and events.size() > scroll_horizontal / size.x:
		selection.select_next()
	if Input.is_action_just_pressed("event_prev") and scroll_horizontal != 0:
		selection.select_prev()
