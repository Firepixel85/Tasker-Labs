extends VBoxContainer
@onready var onboarding: Control = $"../../../../../../../.."
@onready var display_name_field: RGTextField = $MarginContainer/DisplayNameField

func _on_next_slide_selected() -> void:
	if onboarding.slide != 3:
		return
	if onboarding.slide == 4:
		Settings.set_option_value("core.general/display_name",display_name_field.get_text())
	display_name_field.edit()
	if display_name_field.text.is_empty():
		onboarding.disable_next()
	else:
		onboarding.enable_next()

func _on_display_name_field_text_changed(new_text: String) -> void:
	if  new_text.is_empty():
		onboarding.disable_next()
	else:
		onboarding.enable_next()

func _on_display_name_field_text_submitted(new_text: String) -> void:
	if new_text.is_empty():
		display_name_field.incorrect = true
		await get_tree().create_timer(1).timeout
		display_name_field.incorrect = false
		display_name_field.edit()
		return
	onboarding.next_slide()
