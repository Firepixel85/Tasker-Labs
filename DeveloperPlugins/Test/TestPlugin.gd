extends Control

#Events
@onready var create_event: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/CreateEvent/CreateEvent
@onready var remove_event: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/RemoveEvent/RemoveEvent

#Notifications
@onready var create_notification: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/CreateNotification
@onready var notification_title: RGTextField = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/NotificationTitle
@onready var notification_description: RGTextField = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/NotificationDescription
@onready var notification_error: RGToggle = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/VBoxContainer/NotificationError
@onready var notification_duration_text: RGText = $MarginContainer/ScrollContainer/VBoxContainer/CreateNotification/HBoxContainer/NotificationDurationText
var notification_duration:int = 4

#Toasts
@onready var toast_text: RGTextField = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/ToastText
@onready var toast_color: RGDropDown = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/ToastColor
@onready var create_toast: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/CreateToast
@onready var toast_duration_text: RGText = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/ToastDurationText
@onready var toast_duration_down: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/HBoxContainer/ToastDurationDown
@onready var toast_duration_up: RGButton = $MarginContainer/ScrollContainer/VBoxContainer/HBoxContainer/HBoxContainer/ToastDurationUp
var toast_duration := 4
var color_dic = {
	"Red":0,
	"Yellow":1,
	"Orange":2,
	"Green":3,
	"Teal":4,
	"Blue":5,
	"Pink":6,
	"Purple":7
}

const ID = "com.rosepen.test"

func _on_create_event_pressed() -> void:
	Debug.log("Creating test event",ID)
	create_event.set_disabled(true)
	remove_event.set_disabled(false)
	var response = Events.add_event(ID,load("res://DeveloperPlugins/Test/test_event.tscn"),load("res://DeveloperPlugins/Test/icon.png"))
	Debug.log("Got response from EventsManager: "+error_string(response),ID)

func _on_remove_event_pressed() -> void:
	Debug.log("Removing test event",ID)
	create_event.set_disabled(false)
	remove_event.set_disabled(true)
	var response = Events.remove_event(ID)
	Debug.log("Got response from EventsManager: "+error_string(response),ID)

func _ready() -> void:
	Settings.setting_changed.connect(_update_buttons)
	create_event.set_color(Settings.get_option_value("core.appearance/accent_color"))
	remove_event.set_color(Settings.get_option_value("core.appearance/accent_color"))
	create_notification.set_color(Settings.get_option_value("core.appearance/accent_color"))
	notification_error.set_color(Settings.get_option_value("core.appearance/accent_color"))
	create_toast.set_color(Settings.get_option_value("core.appearance/accent_color"))
	notification_error.set_accessible(Settings.get_option_value("core.accessibility/symbol_indicators"))
	notification_title.set_text("Test")
	notification_description.set_text("This is a test notification's description... It should describe why the user is getting this notification.")
	toast_text.set_text("This is a toast")
	if Events.event_exists(ID):
		create_event.set_disabled(true)
		remove_event.set_disabled(false)

	toast_color.add_item("Red",0)
	toast_color.add_item("Yellow",1)
	toast_color.add_item("Orange",2)
	toast_color.add_item("Green",3)
	toast_color.add_item("Teal",4)
	toast_color.add_item("Blue",5)
	toast_color.add_item("Pink",6)
	toast_color.add_item("Purple",7)
	toast_color.select(color_dic[Settings.get_option_value("core.appearance/accent_color")])

func _update_buttons(option_path,new_value):
	if option_path == "core.appearance/accent_color":
		create_event.set_color(new_value)
		remove_event.set_color(new_value)
		create_notification.set_color(new_value)
		notification_error.set_color(new_value)
		create_toast.set_color(new_value)

func _on_create_notification_pressed() -> void:
	Debug.log("Queuing notification",ID)
	var response = NotificationManager.queue_notification(notification_title.get_text(),notification_description.get_text(),notification_error.is_toggled,null,[],notification_duration)
	Debug.log("Got response from NotificationManager: "+error_string(response),ID)

func _on_notification_duration_down_pressed() -> void:
	if notification_duration == 0:
		return
	notification_duration -=1
	notification_duration_text.set_text("Duration: "+str(notification_duration)+"s")

func _on_notification_duration_up_pressed() -> void:
	notification_duration +=1
	notification_duration_text.set_text("Duration: "+str(notification_duration)+"s")

func _on_create_toast_pressed() -> void:
	Debug.log("Creating toast",ID)
	var response = RoseGarden.create_toast(toast_text.get_text(),toast_color.get_selected_item(),toast_duration)
	Debug.log("Got response from RoseGarden: "+error_string(response),ID)

func _on_toast_duration_up_pressed() -> void:
	toast_duration += 1
	toast_duration_text.set_text("Duration: "+str(notification_duration)+"s")

func _on_toast_duration_down_pressed() -> void:
	if toast_duration == 0:
		return
	toast_duration -=1
	toast_duration_text.set_text("Duration: "+str(toast_duration)+"s")
