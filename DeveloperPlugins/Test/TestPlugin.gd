extends Control

@onready var create_event: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/CreateEvent/CreateEvent
@onready var remove_event: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/RemoveEvent/RemoveEvent


#Notifications
@onready var create_notification: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/CreateNotification
@onready var notification_title: RGTextField = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/NotificationTitle
@onready var notification_description: RGTextField = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/NotificationDescription
@onready var notification_error: RGToggle = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/VBoxContainer/NotificationError
@onready var notification_duration_text: RGText = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/NotificationDurationText

const ID = "com.rosepen.test"

var notification_duration:int = 4
func _on_create_event_pressed() -> void:
	create_event.set_disabled(true)
	remove_event.set_disabled(false)
	#Events.add_event("com.rosepen.test",load("res://DeveloperPlugins/Test/test_event.tscn"),Icons.CHECKBOOK)
	Events.add_event(ID,load("res://DeveloperPlugins/Test/test_event.tscn"),load("res://DeveloperPlugins/Test/icon.png"))

func _on_remove_event_pressed() -> void:
	create_event.set_disabled(false)
	remove_event.set_disabled(true)
	Events.remove_event(ID)

func _ready() -> void:
	Settings.setting_changed.connect(_update_buttons)
	create_event.set_color(Settings.get_option_value("core.appearance/accent_color"))
	remove_event.set_color(Settings.get_option_value("core.appearance/accent_color"))
	create_notification.set_color(Settings.get_option_value("core.appearance/accent_color"))
	notification_error.set_color(Settings.get_option_value("core.appearance/accent_color"))
	notification_error.set_accessible(Settings.get_option_value("core.accessibility/symbol_indicators"))
	notification_title.set_text("Test")
	notification_description.set_text("This is a test notification")
	if Events.event_exists(ID):
		create_event.set_disabled(true)
		remove_event.set_disabled(false)

func _update_buttons(option_path,new_value):
	if option_path == "core.appearance/accent_color":
		create_event.set_color(new_value)
		remove_event.set_color(new_value)
		create_notification.set_color(new_value)
		notification_error.set_color(new_value)
	if option_path == "core.accessibility/symbol_indicators":
		notification_error.set_accessible(new_value)


func _on_create_notification_pressed() -> void:
	NotificationManager.queue_notification(notification_title.get_text(),notification_description.get_text(),notification_error.is_toggled,null,[],notification_duration)


func _on_notification_duration_down_pressed() -> void:
	if notification_duration == 0:
		return
	notification_duration -=1
	notification_duration_text.set_text("Duration: "+str(notification_duration)+"s")


func _on_notification_duration_up_pressed() -> void:
	notification_duration +=1
	notification_duration_text.set_text("Duration: "+str(notification_duration)+"s")
