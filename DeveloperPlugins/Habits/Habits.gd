extends Control

const ID = "com.rosepen.habits"
@onready var habits_container: HFlowContainer = $MarginContainer/VBoxContainer/MarginContainer/ScrollContainer/HFlowContainer
@onready var create_button: RGButton = $MarginContainer/VBoxContainer/HBoxContainer/CreateButton
@onready var keybind_timer: Timer = $KeybindTimer

var last_given_id:int = -1
var active_ids := []
var keybinds_shown:bool = false
var keys := {
	"1":KEY_1,
	"2":KEY_2,
	"3":KEY_3,
	"4":KEY_4,
	"5":KEY_5,
	"6":KEY_6,
	"7":KEY_7,
	"8":KEY_8,
	"9":KEY_9,
	"0":KEY_0
}

func _on_create_button_pressed() -> void:
	Popups.create_popup(load(PluginManager.get_plugin_filepath(ID)+"Popups/CreateHabit.tscn"))
	await Popups.popup_created
	Popups.get_popup().habit_created.connect(_habit_created)

func _input(_event: InputEvent) -> void:
	if Sidebar.get_selected_tab() != ID:
		return
	if Input.is_action_just_pressed("create_new_habit"):
		create_button.press()
		get_viewport().set_input_as_handled()
	if Input.is_key_pressed(KEY_SHIFT) and keybind_timer.is_stopped() and !keybinds_shown:
		keybind_timer.start()
	if !Input.is_key_pressed(KEY_SHIFT):
		keybind_timer.start()
		if keybinds_shown:
			for child in habits_container.get_children():
				child.hide_keybind()
			keybinds_shown = false
		return
	for i in range(1,11):
		if Input.is_key_pressed(keys[str(i%10)]):
			if Input.is_action_just_pressed("E"):
				_get_habit(i).edit()
			elif Input.is_action_just_pressed("F"):
				if _get_habit(i).habit.frozen:
					_get_habit(i).unfreeze()
				else:
					_get_habit(i).freeze_confirmed()
			elif Input.is_action_just_pressed("D"):
				_get_habit(i).delete()
			elif Input.is_action_just_pressed("C"):
				_get_habit(i).check_in()


func _on_keybind_timer_timeout() -> void:
	if keybinds_shown or !Input.is_key_pressed(KEY_SHIFT):
		return
	for i in habits_container.get_child_count():
		habits_container.get_child(i).show_keybind(i+1)
	keybinds_shown = true

func _get_habit(num:int):
	return habits_container.get_child(num-1)

func _habit_created(habit_name:String,goal:int):
	Debug.error("Name: %s Goal: "%habit_name+str(goal),ID)
	Popups.get_popup().habit_created.disconnect(_habit_created)
	var today = Date.new(Time.get_date_dict_from_system()["day"],Time.get_date_dict_from_system()["month"],Time.get_date_dict_from_system()["year"])
	var habit = Habit.new(habit_name,goal,0,0,false,today)
	var new_habit = load(PluginManager.get_plugin_filepath(ID)+"Habit/Habit.tscn").instantiate()
	habits_container.add_child(new_habit)
	last_given_id += 1
	active_ids.append(int(last_given_id))
	new_habit.setup(habit,last_given_id)
	var file_name = ID+"/Habit_"+str(last_given_id)
	Data.make_file("Habit_"+str(last_given_id),ID)
	Data.save_to("name",habit.get_display_name(),file_name)
	Data.save_to("goal",habit.get_goal(),file_name)
	Data.save_to("streak",habit.get_streak(),file_name)
	Data.save_to("best_streak",habit.get_best_streak(),file_name)
	Data.save_to("checked_in",habit.get_checked_in(),file_name)
	Data.save_to("frozen",habit.get_frozen(),file_name)
	Data.save_to("last_check_in",[habit.get_last_check_in().get_day(), habit.get_last_check_in().get_month(), habit.get_last_check_in().get_year()],file_name)
	Data.save_file(file_name)
	save()


func save(save_habits:=false):
	Data.save_to("last_given_id",last_given_id,ID+"/Habits")
	Data.save_to("active_ids",active_ids,ID+"/Habits")
	Data.save_file(ID+"/Habits")
	
	if !save_habits:
		return
	for habit_node in habits_container.get_children():
		var habit:Habit = habit_node.habit
		var file_name = ID+"/Habit_"+str(habit_node.id)

		Data.save_to("name",habit.get_display_name(),file_name)
		Data.save_to("goal",habit.get_goal(),file_name)
		Data.save_to("streak",habit.get_streak(),file_name)
		Data.save_to("best_streak",habit.get_best_streak(),file_name)
		Data.save_to("checked_in",habit.get_checked_in(),file_name)
		Data.save_to("frozen",habit.get_frozen(),file_name)
		Data.save_to("last_check_in",[habit.get_last_check_in().get_day(), habit.get_last_check_in().get_month(), habit.get_last_check_in().get_year()],file_name)
		Data.save_file(file_name)

func save_habit(habit_id:int):
	for habit_node in habits_container.get_children():
		if habit_node.id != habit_id:
			continue
			
		var habit:Habit = habit_node.habit
		var file_name = ID+"/Habit_"+str(habit_node.id)
		Data.save_to("name",habit.get_display_name(),file_name)
		Data.save_to("goal",habit.get_goal(),file_name)
		Data.save_to("streak",habit.get_streak(),file_name)
		Data.save_to("best_streak",habit.get_best_streak(),file_name)
		Data.save_to("checked_in",habit.get_checked_in(),file_name)
		Data.save_to("frozen",habit.get_frozen(),file_name)
		Data.save_to("last_check_in",[habit.get_last_check_in().get_day(), habit.get_last_check_in().get_month(), habit.get_last_check_in().get_year()],file_name)
		Data.save_file(file_name)

func _ready() -> void:
	CommandBar.add_command("Edit habit",ID,PluginManager.get_plugin_filepath(ID)+"icon.png",select_habit_to,['Edit'])
	CommandBar.add_command("Freeze habit",ID,PluginManager.get_plugin_filepath(ID)+"icon.png",select_habit_to,['Freeze'])
	CommandBar.add_command("Delete habit",ID,PluginManager.get_plugin_filepath(ID)+"icon.png",select_habit_to,['Delete'])
	CommandBar.add_command("Check in/out for habit",ID,PluginManager.get_plugin_filepath(ID)+"icon.png",select_habit_to,['Check In'])
	
	if Data.file_exists(ID+"/Habits"):
		var data = Data.load_file(ID+"/Habits")
		last_given_id = data["last_given_id"]
		for id in data["active_ids"]:
			active_ids.append(int(id))
		for id in active_ids:
			var file_name = ID+"/Habit_"+str(int(id))
			data = Data.load_file(file_name)
			var habit := Habit.new(data["name"],data["goal"],data["streak"],data["best_streak"],data["checked_in"],Date.new(data["last_check_in"][0],data["last_check_in"][1],data["last_check_in"][2]),data["frozen"])
			var today = Date.new(Time.get_date_dict_from_system()["day"],Time.get_date_dict_from_system()["month"],Time.get_date_dict_from_system()["year"])
			if !(habit.get_last_check_in().is_prev_of(today) or habit.get_last_check_in().is_same_as(today)) and !habit.get_frozen():
				habit.set_streak(0)
			if !habit.get_last_check_in().is_same_as(today):
				habit.set_checked_in(false)
			var new_habit = load(PluginManager.get_plugin_filepath(ID)+"Habit/Habit.tscn").instantiate()
			habits_container.add_child(new_habit)
			new_habit.setup(habit,id)
	else:
		Data.make_file("Habits",ID)
		save()

func delete_habit(habit_id:int):
	if !active_ids.has(habit_id):
		Debug.warn("A process tried to delete a habit that does not exist (Habit %s)"%str(habit_id),ID)
		return ERR_DOES_NOT_EXIST
	active_ids.erase(habit_id)
	Data.remove_file(ID+"/Habit_"+str(habit_id))
	Debug.log("Habit %s deleted"%str(habit_id),ID)
	save()

func select_habit_to(action:String):
	Popups.create_popup(load(PluginManager.get_plugin_filepath(ID)+"Popups/ActionPopup.tscn"))
	var habits := {}
	for i in habits_container.get_child_count():
		habits[i] = habits_container.get_child(i).habit.display_name
	await Popups.popup_created
	Popups.get_popup().setup(action,habits)
	match action:
		"Edit":
			Popups.get_popup().habit_selected.connect(_edit_select_habit)
		"Freeze":
			Popups.get_popup().habit_selected.connect(_freeze_select_habit)
		"Delete":
			Popups.get_popup().habit_selected.connect(_delete_select_habit)
		"Check In":
			Popups.get_popup().habit_selected.connect(_check_in_select_habit)
	
	
func _edit_select_habit(num:int):
	await Popups.popup_cleared
	habits_container.get_child(num).edit()
	
func _freeze_select_habit(num:int):
	if habits_container.get_child(num).habit.frozen:
		habits_container.get_child(num).unfreeze()
	else:
		habits_container.get_child(num).freeze_confirmed()
	
func _delete_select_habit(num:int):
	await Popups.popup_cleared
	habits_container.get_child(num).delete()
	
func _check_in_select_habit(num:int):
	habits_container.get_child(num).check_in()
