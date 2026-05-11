extends Node

const ID = "core.popups"
var popup_container:CenterContainer
var popup_fade:TextureRect
var popup:Resource = null

func add_popup(popup_scene:Resource):
	if popup != null:
		Debug.error("Attempted to add popup while another popup is active",ID)
		return ERR_ALREADY_EXISTS
	popup = popup_scene
	popup_container.visible = true
	popup_fade.visible = true
	popup_container.add_child(popup.instantiate())
	Debug.log("Popup added",ID)
	pass

func remove_popup():
	if popup == null:
		Debug.error("Attempted to remove popup when no popup is active",ID)
	popup_container.get_child(0).queue_free()
	popup_fade.visible = false
	popup_container.visible = false
	popup = null
	Debug.log("Popup removed",ID)
