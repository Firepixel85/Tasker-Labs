extends Node

var logs = []

func log(message:String, logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" INFO: "+message)
	logs.append(Main.get_process_name(logger_id)+" INFO: "+message)

func warn(message:String,logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" WARN: "+message)
	logs.append(Main.get_process_name(logger_id)+" WARN: "+message)

func error(message:String,logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" ERROR: "+message)
	logs.append(Main.get_process_name(logger_id)+" ERROR: "+message)

func get_logs():
	return logs

func clear_logs():
	logs = []
