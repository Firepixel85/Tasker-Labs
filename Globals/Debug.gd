extends Node

var logs = []
var log_type = []
var log_seconds = []

var log_count:int = 0
var warn_count:int = 0
var error_count:int = 0

var run_seconds:int = 0##How many seconds the program has been running for, used for log timestamps

signal logs_changed
func log(message:String, logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" INFO: "+message)
	logs.append(Main.get_process_name(logger_id)+" INFO: "+message)
	log_seconds.append(run_seconds)
	log_type.append("Info")
	log_count +=1
	logs_changed.emit()

func warn(message:String,logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" WARN: "+message)
	logs.append(Main.get_process_name(logger_id)+" WARN: "+message)
	log_seconds.append(run_seconds)
	log_type.append("Warn")
	warn_count +=1
	logs_changed.emit()

func error(message:String,logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" ERROR: "+message)
	logs.append(Main.get_process_name(logger_id)+" ERROR: "+message)
	log_seconds.append(run_seconds)
	log_type.append("Error")
	error_count +=1
	logs_changed.emit()

func get_logs():
	return logs

func clear_logs():
	log_count = 0
	warn_count = 0
	error_count = 0
	logs = []
	log_type = []

func _ready() -> void:
	while true:
		await get_tree().create_timer(1).timeout
		run_seconds += 1

func get_formated_time(time:int):
	@warning_ignore("integer_division")
	var hours = floor(time/3600)
	@warning_ignore("integer_division")
	var minutes = floor((time%3600)/60)
	var seconds = floor(time%60)
	var time_string := ""
	if run_seconds>3600:
		if hours<10:
			time_string += "0"
		time_string += str(hours)+":"
		if minutes<10:
			time_string += "0"
		time_string += str(minutes)
		time_string += ":"
		if seconds<10:
			time_string += "0"
		time_string += str(seconds)
	elif run_seconds>60:
		if minutes<10:
			time_string += "0"
		time_string += str(minutes)
		time_string += ":"
		if seconds<10:
			time_string += "0"
		time_string += str(seconds)
	else:
		if seconds<10:
			time_string += "0"
		time_string += str(seconds)
	return time_string
