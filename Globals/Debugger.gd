extends Control
@onready var drop_down: RGDropDown = $"MarginContainer/VBoxContainer/Content/Drop Down/Drop Down"
@onready var segment_control: RGSegmentControl = $"MarginContainer/VBoxContainer/Content/Segment Control/SegmentControl"
@onready var segment_control_icon: RGSegmentControlIcon = $"MarginContainer/VBoxContainer/Content/Segment Control/SegmentControl Icon"
@onready var accent_dropdown: RGDropDown = $"MarginContainer/VBoxContainer/HBoxContainer/Drop Down"
@onready var rg_section_view: RGSectionView = $"MarginContainer/VBoxContainer/Content/Section View/VBoxContainer/RGSectionView"

#Buttons
@onready var button_text: RGButton = $MarginContainer/VBoxContainer/Content/ButtonText/RGButton3
@onready var button_text_icon: RGButton = $MarginContainer/VBoxContainer/Content/ButtonTextIcon/RGButton3
@onready var button_icon: RGButton = $MarginContainer/VBoxContainer/Content/ButtonIcon/RGButton3
@onready var toggle: Control = $MarginContainer/VBoxContainer/Content/Toggle/Toggle2
@onready var toggle_acc: Control = $MarginContainer/VBoxContainer/Content/Toggle/Toggle7

func _ready() -> void:
	segment_control.add_item("home","Home")
	segment_control.add_item("focus","Focus")
	segment_control.add_item("tasks","Tasks")
	segment_control_icon.add_item("home",load("res://Icons/Home.svg"))
	segment_control_icon.add_item("focus",load("res://Icons/Book.svg"))
	segment_control_icon.add_item("tasks",load("res://Icons/Checklist.svg"))
	drop_down.add_item("Option 1",0)
	drop_down.add_item("Option 2",1)
	drop_down.add_item("Option 3",2)
	accent_dropdown.add_item("Red",0)
	accent_dropdown.add_item("Orange",1)
	accent_dropdown.add_item("Yellow",2)
	accent_dropdown.add_item("Green",3)
	accent_dropdown.add_item("Blue",4)
	accent_dropdown.add_item("Pink",5)
	accent_dropdown.add_item("Purple",6)
	accent_dropdown.add_item("Tasker",7)

func _on_accent_changed(selection:String) -> void:
	button_text.set_color(selection)
	button_icon.set_color(selection)
	button_text_icon.set_color(selection)
	toggle.set_color(selection)
	toggle_acc.set_color(selection)


func _on_rg_button_pressed() -> void:
	rg_section_view.select_prev()


func _on_rg_button_2_pressed() -> void:
	rg_section_view.select_next()
	
