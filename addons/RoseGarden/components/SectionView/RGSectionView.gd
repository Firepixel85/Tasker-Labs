@tool
extends Control
class_name RGSectionView

@onready var section_container: HBoxContainer = $HBoxContainer

@export var sections: int = 1

var selected = 1

signal section_added
signal section_removed
signal section_selected(new_selection)


func add_section():
	sections += 1
	section_container.add_child(preload("res://addons/RoseGarden/components/SectionView/RGsection.tscn").instantiate())
	var target: TextureRect = section_container.get_children()[
		section_container.get_children().size() - 1
	]
	target.id = sections
	target.manager = self
	target._ready()
	await target.ready
	section_added.emit()
	custom_minimum_size.x = section_container.size.x
	return OK


func remove_section():
	if sections == 1:
		return ERR_LOCKED
	sections -= 1
	section_removed.emit()
	return OK


func select(section: int):
	if !section >= 1 and !section <= sections:
		return ERR_PARAMETER_RANGE_ERROR
	selected = section
	section_selected.emit(selected)
	return OK


func select_next():
	if selected == sections:
		return ERR_DOES_NOT_EXIST
	select(selected + 1)
	return OK


func select_prev():
	if selected == 1:
		return ERR_DOES_NOT_EXIST
	select(selected - 1)
	return OK


func get_selected():
	return selected


func getsections():
	return sections


##############
#### STOP #### Here begin private functions that should never be called by your code
##############


func _ready() -> void:
	for i in sections:
		_display_section(i + 1)


func _display_section(section: int):  #Adds a section without updating vars, used for loading orginal sections in _ready()
	section_container.add_child(preload("res://addons/RoseGarden/components/SectionView/RGsection.tscn").instantiate())
	var target: NinePatchRect = section_container.get_children()[
		section_container.get_children().size() - 1
	]
	target.manager = self
	target.id = section
	target._ready()
	section_added.emit()
	custom_minimum_size.x = 20 * (sections - 1) + 48
	return OK
