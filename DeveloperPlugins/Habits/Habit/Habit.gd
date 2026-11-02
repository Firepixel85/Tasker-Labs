extends Control

@onready var display_name: RGText = $RGContainer/MarginContainer/VBoxContainer/Name
@onready var streak_text: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/StreakContainer/Streak
@onready var goal_text: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/GoalContainer/Goal
@onready var best_streak_text: RGText = $RGContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/BSContainer/BestStreak
@onready var check_in_button: RGButton = $RGContainer/MarginContainer/VBoxContainer/HBoxContainer/CheckIn
@onready var flame: Control = $RGContainer/MarginContainer/VBoxContainer/CenterContainer/Flame
@onready var keybind: TextureRect = $RGContainer/MarginContainer/Keybind

var habit:Habit
var old_last_check_in:Date
var old_goal:int
var id:int

func setup(new_habit:Habit,new_id:int):
	id = new_id
	habit = new_habit
	display_name.set_text(habit.get_display_name())
	_update()
	old_last_check_in = habit.get_last_check_in()
	if habit.streak >= habit.goal:
		flame.set_color("Purple")
	else:
		flame.set_color("Red")
	if habit.checked_in:
		flame.set_new_size("Big")
	else:
		flame.set_new_size("Small")
	if habit.frozen:
		check_in_button.show_tooltip = true

func _update():
	if habit.get_streak() > habit.get_best_streak():
		habit.set_best_streak(habit.get_streak())
	display_name.set_text(habit.display_name)
	streak_text.set_text(str(habit.get_streak()))
	best_streak_text.set_text(str(habit.get_best_streak()))
	goal_text.set_text(str(habit.get_goal()))
	check_in_button.set_disabled(false)
	if habit.get_checked_in():
		check_in_button.set_color("Gray")
		check_in_button.set_text("Check Out")
	else:
		check_in_button.set_color("White")
		check_in_button.set_text("Check In")
	if habit.get_frozen():
		check_in_button.set_disabled(true)
		check_in_button.set_color("Blue")
		check_in_button.set_text("Frozen")
	Sidebar.get_tab("com.rosepen.habits").save_habit(id)
	

func _on_check_in_pressed() -> void:
	if habit.get_checked_in():
		habit.set_checked_in(false)
		habit.set_streak(habit.get_streak()-1)
		habit.set_last_check_in(old_last_check_in)
		_update()
		if habit.streak == habit.goal-1:
			flame.play("GoalTransRev")
			_update()
			return
		flame.play("TransRev")
	else:
		habit.set_checked_in(true)
		habit.set_streak(habit.get_streak()+1)
		habit.set_last_check_in(Date.new(Time.get_date_dict_from_system()["day"],Time.get_date_dict_from_system()["month"],Time.get_date_dict_from_system()["year"]))
		if habit.streak == habit.goal:
			Popups.create_popup(load(PluginManager.get_plugin_filepath("com.rosepen.habits")+"Popups/GoalHit.tscn"))
			await get_tree().create_timer(0.2).timeout
			flame.play("GoalTrans")
			_update()
			return
		_update()
		flame.play("Trans")

func _on_more_pressed() -> void:
	var menu = RGmenu.new()
	menu.add_action("Edit",Icons.PENCIL,edit)
	if habit.frozen:
		menu.add_action("Unfreeze",Icons.SNOWFLAKE,unfreeze)
	else:
		menu.add_action("Freeze",Icons.SNOWFLAKE,freeze)
	menu.add_action("Delete",Icons.TRASH,delete,[],true)
	RoseGarden.create_rc_menu(menu,get_global_mouse_position())

func edit():
	Popups.create_popup(load(PluginManager.get_plugin_filepath("com.rosepen.habits")+"Popups/EditHabit.tscn"))
	await Popups.popup_created
	Popups.get_popup().setup(habit)
	old_goal = habit.goal
	Popups.get_popup().habit_edited.connect(_habit_edited)

func _habit_edited(new_habit:Habit):
	if habit.goal != old_goal:
		if habit.streak >= habit.goal:
			flame.set_color("Purple")
		else:
			flame.set_color("Red")
		if habit.checked_in:
			flame.set_new_size("Big")
		else:
			flame.set_new_size("Small")
	habit = new_habit
	_update()

func freeze():
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.DOUBLE_ACTION)
	popup.set_title("Freeze habit?")
	popup.title_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.set_description("Are you sure you want to freeze this habit? You won’t lose your streak if you miss a day, but you also won’t be able to check-in. You can un-freeze this habit whenever you want.")
	popup.description_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.hide_close_button()
	popup.add_action(empty,"Cancel",[],"Gray")
	popup.add_action(freeze_confirmed,"Freeze",[],"Blue")
	Popups.create_prefab_popup(popup)

func freeze_confirmed():
	habit.set_frozen(true)
	if habit.checked_in:
		flame.play("TransRev")
	flame.set_color("Blue")
	check_in_button.show_tooltip = true
	_update()
	
func unfreeze():
	habit.set_frozen(false)
	habit.set_last_check_in(Date.new(Time.get_date_dict_from_system()["day"],Time.get_date_dict_from_system()["month"],Time.get_date_dict_from_system()["year"]).get_prev())
	_update()
	if habit.streak >= habit.goal:
		flame.set_color("Purple")
	else:
		flame.set_color("Red")
	if habit.checked_in:
		flame.play("Trans")
	check_in_button.show_tooltip = false

func delete():
	var popup = TSKPopup.new()
	popup.set_type(TSKPopup.DOUBLE_ACTION)
	popup.set_title("Are you sure?")
	popup.title_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.set_description("Deleting this habit is a permanent action, that can not be undone. Your steak will be lost. ")
	popup.description_alignment = TSKPopup.ALIGNMENT_CENTER
	popup.hide_close_button()
	popup.add_action(empty,"Cancel",[],"Gray")
	popup.add_action(delete_confirmed,"Delete",[],"Red")
	Popups.create_prefab_popup(popup)

func delete_confirmed():
	Sidebar.get_tab("com.rosepen.habits").delete_habit(id)
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self,"modulate",Color(1,1,1,0),0.2*int(!RoseGarden.Accessibility.get_disable_animations())).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"scale",Vector2(0,0),0.2*int(!RoseGarden.Accessibility.get_disable_animations())).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	queue_free()

func empty(): #It is genuenly annoying at this point
	pass

func show_keybind(num:int):
	keybind.texture = load(PluginManager.get_plugin_filepath("com.rosepen.habits")+"Keybinds/Keybind%s.svg"%str(num))
	create_tween().tween_property(keybind,"modulate",Color(1,1,1,1),0.1*int(!RoseGarden.Accessibility.disableAnimations))

func hide_keybind():
	create_tween().tween_property(keybind,"modulate",Color(1,1,1,0),0.1*int(!RoseGarden.Accessibility.disableAnimations))

func check_in():
	if check_in_button.disabled:
		return
	check_in_button.press()
