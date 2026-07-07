extends Node

const ID = "core.popups"
const ANIMATION_TIME = 0.3
var popup_container: CenterContainer
var popup_fade: TextureRect
var popup = null

signal popup_created(popup_node)
signal popup_cleared


func create_popup(popup_scene: Resource):
	if popup != null:
		Debug.error("Attempted to add popup while another popup is active", ID)
		return ERR_ALREADY_EXISTS
	if !popup_scene is PackedScene:
		Debug.error("Attempted to add popup with resource that is not a PackedScene", ID)
		return ERR_INVALID_PARAMETER
	RoseGarden.clear_tooltips()
	popup_container.visible = true
	popup_container.add_child(popup_scene.instantiate())
	return OK


func clear_popup():
	if popup == null:
		Debug.error("Attempted to remove popup when no popup is active", ID)
		return ERR_DOES_NOT_EXIST
	popup.grab_focus()
	var tween = create_tween()
	(
		tween
		. parallel()
		. tween_property(
			popup,
			"scale",
			Vector2(0.8, 0.8),
			ANIMATION_TIME * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		tween
		. parallel()
		. tween_property(
			popup_fade,
			"modulate",
			Color(0, 0, 0, 0),
			ANIMATION_TIME * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		tween
		. parallel()
		. tween_property(
			popup,
			"modulate",
			Color(1, 1, 1, 0),
			ANIMATION_TIME * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	await tween.finished
	if popup_container.get_child_count() > 0:
		popup_container.get_child(0).queue_free()
	popup_fade.visible = false
	popup_container.visible = false
	popup = null
	popup_cleared.emit()
	Debug.log("Popup cleared", ID)
	return OK


func get_popup():
	return popup


func is_popup_active():
	return popup != null


func _ready():
	if popup_container == null:
		return
	popup_container.child_entered_tree.connect(_animate_popup)


func _animate_popup(popup_node):
	await get_tree().process_frame
	popup = popup_node
	popup.pivot_offset_ratio = Vector2(0.5, 0.5)
	popup.scale = Vector2(0.8, 0.8)
	popup_fade.modulate = Color(0, 0, 0, 0)
	popup_fade.modulate = Color(0, 0, 0, 0)
	popup_fade.visible = true
	var tween = create_tween()
	(
		tween
		. parallel()
		. tween_property(
			popup,
			"scale",
			Vector2(1, 1),
			ANIMATION_TIME * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		tween
		. parallel()
		. tween_property(
			popup_fade,
			"modulate",
			Color(0, 0, 0, 0.5),
			ANIMATION_TIME * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	(
		tween
		. parallel()
		. tween_property(
			popup,
			"modulate",
			Color(1, 1, 1, 1),
			ANIMATION_TIME * int(!RoseGarden.Accessibility.disableAnimations)
		)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_CUBIC)
	)
	popup_created.emit(popup)
	Debug.log("Popup created", ID)


func create_prefab_popup(prefab_popup: TSKPopup):
	if popup != null:
		Debug.error("Attempted to add popup while another popup is active", ID)
		return ERR_ALREADY_EXISTS
	if !prefab_popup is TSKPopup:
		Debug.error("Attempted to add popup with resource that is not a TSKPopup", ID)
		return ERR_INVALID_PARAMETER
	RoseGarden.clear_tooltips()
	popup_container.visible = true
	match prefab_popup.type:
		TSKPopup.NO_ACTION:
			var popup_node = preload("res://Popups/Popup0/Popup0.tscn").instantiate()
			popup_container.add_child(popup_node)
			popup_node.setup(
				prefab_popup.title, prefab_popup.description, prefab_popup.title_alignment
			)
		TSKPopup.SINGLE_ACTION:
			var popup_node = preload("res://Popups/Popup1/Popup1.tscn").instantiate()
			popup_container.add_child(popup_node)
			popup_node.setup(
				prefab_popup.title,
				prefab_popup.description,
				prefab_popup.actions[0],
				prefab_popup.action_params[0],
				prefab_popup.action_names[0],
				prefab_popup.colors[0],
				prefab_popup.title_alignment
			)
		TSKPopup.DOUBLE_ACTION:
			var popup_node = preload("res://Popups/Popup2/Popup2.tscn").instantiate()
			popup_container.add_child(popup_node)
			popup_node.setup(
				prefab_popup.title,
				prefab_popup.description,
				prefab_popup.actions,
				prefab_popup.action_params,
				prefab_popup.action_names,
				prefab_popup.colors,
				prefab_popup.title_alignment
			)
	return OK
