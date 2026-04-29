extends Node

var logs = []
var log_type = []

var log_count:int = 0
var warn_count:int = 0
var error_count:int = 0

signal logs_changed
func log(message:String, logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" INFO: "+message)
	logs.append(Main.get_process_name(logger_id)+" INFO: "+message)
	log_type.append("Info")
	log_count +=1
	logs_changed.emit()

func warn(message:String,logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" WARN: "+message)
	logs.append(Main.get_process_name(logger_id)+" WARN: "+message)
	log_type.append("Warn")
	warn_count +=1
	logs_changed.emit()

func error(message:String,logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" ERROR: "+message)
	logs.append(Main.get_process_name(logger_id)+" ERROR: "+message)
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
