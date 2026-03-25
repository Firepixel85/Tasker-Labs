extends Control
@onready var drop_down: RGDropDown = $"MarginContainer/VBoxContainer/Content/Drop Down/Drop Down"
@onready var segment_control: RGSegmentControl = $"MarginContainer/VBoxContainer/Content/Segment Control/SegmentControl"
@onready var segment_control_icon: RGSegmentControlIcon = $"MarginContainer/VBoxContainer/Content/Segment Control/SegmentControl Icon"
@onready var accent_dropdown: RGDropDown = $"MarginContainer/VBoxContainer/HBoxContainer/Drop Down"
@onready var rg_section_view: RGSectionView = $"MarginContainer/VBoxContainer/Content/Section View/VBoxContainer/RGSectionView"
@onready var rg_tag: Control = $MarginContainer/VBoxContainer/Content/HBoxContainer/VBoxContainer/RGTag
@onready var menu_layer: CanvasLayer = $MenuLayer

#Buttons
@onready var button_text: RGButton = $MarginContainer/VBoxContainer/Content/ButtonText/RGButton3
@onready var button_text_icon: RGButton = $MarginContainer/VBoxContainer/Content/ButtonTextIcon/RGButton3
@onready var button_icon: RGButton = $MarginContainer/VBoxContainer/Content/ButtonIcon/RGButton3
@onready var toggle: Control = $MarginContainer/VBoxContainer/Content/Toggle/Toggle2
@onready var toggle_acc: Control = $MarginContainer/VBoxContainer/Content/Toggle/Toggle7

var menu = RGmenu.new()
var submenu = RGmenu.new()
func _ready() -> void:
	RoseGarden.set_menu_layer(menu_layer)

	segment_control.add_item("home","Home")
	segment_control.add_item("focus","Focus")
	segment_control.add_item("tasks","Tasks")

	segment_control_icon.add_item("home",Icons.HOME)
	segment_control_icon.add_item("focus",Icons.BOOK)
	segment_control_icon.add_item("tasks",Icons.CHECKLIST)

	drop_down.add_item("Option 1",0)
	drop_down.add_item("Option 2",1)
	drop_down.add_item("Option 3",2)

	accent_dropdown.add_item("Red",0)
	accent_dropdown.add_item("Orange",1)
	accent_dropdown.add_item("Yellow",2)
	accent_dropdown.add_item("Green",3)
	accent_dropdown.add_item("Teal",4)
	accent_dropdown.add_item("Blue",5)
	accent_dropdown.add_item("Pink",6)
	accent_dropdown.add_item("Purple",7)
	accent_dropdown.add_item("Tasker",8)
	
	#Build menus:
	menu.add_action("Option",Texture2D.new(),empty)
	menu.add_menu("More",Texture2D.new(),submenu)
	menu.add_menu("Selected",Texture2D.new(),submenu)
	menu.add_seperator()
	menu.add_action("Icon",Icons.SCISSORS,empty)
	menu.add_menu("More",Icons.SCISSORS,submenu)
	menu.add_menu("Selected",Icons.SCISSORS,submenu)
	menu.add_seperator()
	menu.add_action("Destructive",Texture2D.new(),empty,[],true)
	menu.add_action("Icon",Icons.TRASH,empty,[],true)
	menu.add_action("Destructive",Icons.TRASH,empty,[],true)
	
	#menu.add_action("Home",Icons.HOME,empty)
	#menu.add_menu("Menu",Icons.CHECKLIST,submenu)
	#menu.add_seperator()
	#menu.add_action("Delete",Icons.TRASH,empty,[],true)
	
	submenu.add_action("Test",Icons.HOME,empty)
	submenu.add_action("Test2",Icons.HOME,empty)
	submenu.add_action("Test3",Icons.HOME,empty)

func _on_accent_changed(selection:String) -> void:
	button_text.set_color(selection)
	button_icon.set_color(selection)
	button_text_icon.set_color(selection)
	toggle.set_color(selection)
	toggle_acc.set_color(selection)
	rg_tag.set_color(selection)

func _on_rg_button_pressed() -> void:
	rg_section_view.select_prev()


func _on_rg_button_2_pressed() -> void:
	rg_section_view.select_next()

func _on_tag_text_changed(new_text: String) -> void:
	rg_tag.set_text(new_text)


func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_RIGHT and event.pressed:
			RoseGarden.create_rc_menu(menu,get_global_mouse_position())

func empty():#Placeholder function used for right click menu examples
	pass
