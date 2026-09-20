extends Control

@onready var hotkey_container: VBoxContainer = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/VBoxContainer
@onready var fade_top: TextureRect = $RGContainer/MarginContainer2/VBoxContainer/FadeTop
@onready var fade_bottom: TextureRect = $RGContainer/MarginContainer2/VBoxContainer/FadeBottom
@onready var scroll_container: ScrollContainer = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/ScrollContainer
@onready var search: RGTextFieldIcon = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/Search

func _ready() -> void:
	for hotkey in HotkeyManager.get_hotkey_list():
		var hotkey_node = preload("res://MainView/Hotkey.tscn").instantiate()
		hotkey_container.add_child(hotkey_node)
		hotkey_node.setup(hotkey)
	search.edit()

func _on_close_pressed() -> void:
	Popups.clear_popup()

func _on_search_text_changed(new_text: String) -> void:
	for child in hotkey_container.get_children():
		child.queue_free()
	var ranked_hotkeys = rank_hotkeys(new_text)
	for hotkey in ranked_hotkeys.keys():
		if ranked_hotkeys[hotkey] == 0 and new_text != "":
			continue
		var hotkey_node = preload("res://MainView/Hotkey.tscn").instantiate()
		hotkey_container.add_child(hotkey_node)
		hotkey_node.setup(hotkey)
	
func rank_hotkeys(input:String):
	var hotkeys := {}
	for hotkey in HotkeyManager.get_hotkey_list():
		hotkeys[hotkey] = score_hotkey(hotkey,input)
	var ranked_hotkeys:Array = hotkeys.keys()
	var hotkey_points:Array = hotkeys.values()
	_sort_parallel_arrays(hotkey_points,ranked_hotkeys)
	var result := {}
	for hotkey in ranked_hotkeys:
		result[hotkey] = hotkeys[hotkey]
	return result

func score_hotkey(hotkey_id:String,input:String):
	input = input.to_lower()
	var hotkey = HotkeyManager.get_hotkey_name(hotkey_id).to_lower()
	var keyword_full_match:bool = false
	var keyword_partial_match:bool = false

	if input == hotkey:
		return 10
	for keyword in HotkeyManager.get_hotkey_keywords(hotkey_id):
		if keyword == input:
			keyword_full_match = true
			break
		if keyword.begins_with(input) or _is_substring(keyword,input):
			keyword_partial_match = true
			break
	if hotkey.begins_with(input) or keyword_full_match:
		return 8
	elif _is_substring(hotkey,input) or keyword_partial_match:
		return 6
	elif input == _get_acronym(hotkey):
		return 4
	return 0
	
func _is_substring(haystack:String,needle:String):
	var found_index = haystack.find(needle)
	if found_index != -1:
		var length_difference = haystack.length() - needle.length()
		if length_difference == 1:
			return false
		else:
			return length_difference
	else:
		return false
		
func _get_acronym(command_name:String):
	var acronym = ""
	for word in command_name.split(" "):
		acronym += word.split("")[0]
	return acronym

func _sort_parallel_arrays(values_array: Array, items_array: Array) -> void:
	if values_array.size() != items_array.size():
		return
	if values_array.is_empty():
		return
	var paired_data: Array = []
	for i in range(values_array.size()):
		paired_data.append({ "value": values_array[i], "item": items_array[i] })
	paired_data.sort_custom(Callable(self, "_compare_paired_data_by_value"))
	for i in range(paired_data.size()):
		values_array[i] = paired_data[i]["value"]
		items_array[i] = paired_data[i]["item"]

func _compare_paired_data_by_value(a: Dictionary, b: Dictionary) -> bool:
	return a["value"] > b["value"]
