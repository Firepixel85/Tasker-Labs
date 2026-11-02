extends Node
class_name Habit

var goal:int:
	set(new_value):
		if new_value >= 0:
			goal = new_value
var streak:int:
	set(new_value):
		if new_value >= 0:
			streak = new_value
var best_streak:int:
	set(new_value):
		if new_value >= 0:
			best_streak = new_value
var display_name:String:
	set(new_value):
		display_name = new_value
var checked_in:bool = false
var last_check_in:Date
var frozen:bool = false

func _init(new_name:String = "", new_goal:int = 0, new_streak:int = 0, new_best_streak:int = 0,new_checked_in:bool = false, new_last_check_in:Date = Date.new(1,1,1), new_frozen:bool = false) -> void:
	goal = new_goal
	streak = new_streak
	best_streak = new_best_streak
	display_name = new_name
	checked_in = new_checked_in
	last_check_in = new_last_check_in
	frozen = new_frozen

func get_display_name() -> String:
	return display_name

func set_display_name(new_name:String) -> void:
	display_name = new_name

func get_goal() -> int:
	return goal

func set_goal(new_goal:int) -> void:
	if new_goal >= 0:
		goal = new_goal

func get_streak() -> int:
	return streak

func set_streak(new_streak:int) -> void:
	if new_streak >= 0:
		streak = new_streak

func get_best_streak() -> int:
	return best_streak

func set_best_streak(new_best_streak:int) -> void:
	if new_best_streak >= 0:
		best_streak = new_best_streak

func get_checked_in() -> bool:
	return checked_in

func set_checked_in(new_checked_in:bool) -> void:
	checked_in = new_checked_in

func get_last_check_in() -> Date:
	return last_check_in

func set_last_check_in(new_last_check_in:Date) -> void:
	last_check_in = new_last_check_in

func get_frozen() -> bool:
	return frozen

func set_frozen(new_frozen:bool) -> void:
	frozen = new_frozen
