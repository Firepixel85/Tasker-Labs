extends Node

const ID = "core.popups"
const ANIMATION_TIME = 0.3
var popup_container:CenterContainer
var popup_fade:TextureRect
var popup = null

signal popup_added(popup_node)
signal popup_removed

func add_popup(popup_scene:Resource):
	if popup != null:
		Debug.error("Attempted to add popup while another popup is active",ID)
		return ERR_ALREADY_EXISTS
	if !popup_scene is PackedScene:
		Debug.error("Attempted to add popup with resource that is not a PackedScene",ID)
		return ERR_INVALID_PARAMETER
	RoseGarden.clear_tooltips()
	popup_container.visible = true
	popup_container.add_child(popup_scene.instantiate())
	return OK


func remove_popup():
	if popup == null:
		Debug.error("Attempted to remove popup when no popup is active",ID)
		return ERR_DOES_NOT_EXIST
	var tween = create_tween()
	tween.parallel().tween_property(popup,"scale",Vector2(0.8,0.8),ANIMATION_TIME*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(popup_fade,"modulate",Color(0,0,0,0),ANIMATION_TIME*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(popup,"modulate",Color(1,1,1,0),ANIMATION_TIME*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	popup_container.get_child(0).queue_free()
	popup_fade.visible = false
	popup_container.visible = false
	popup = null
	popup_removed.emit()
	Debug.log("Popup removed",ID)
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
	popup.pivot_offset_ratio = Vector2(0.5,0.5)
	popup_fade.modulate = Color(0,0,0,0)
	popup.scale = Vector2(0.8,0.8)
	popup_fade.modulate = Color(0,0,0,0)
	popup_fade.visible = true
	var tween = create_tween()
	tween.parallel().tween_property(popup,"scale",Vector2(1,1),ANIMATION_TIME*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(popup_fade,"modulate",Color(0,0,0,0.5),ANIMATION_TIME*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(popup,"modulate",Color(1,1,1,1),ANIMATION_TIME*int(!RoseGarden.Accessibility.disableAnimations)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	popup_added.emit(popup)
	Debug.log("Popup added",ID)
