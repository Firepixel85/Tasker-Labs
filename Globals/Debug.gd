extends Node

var logs = []
func log(message:String, logger_id:String="unknown"):
	print(Main.get_process_name(logger_id)+" INFO: "+message)
	logs.append(Main.get_process_name(logger_id)+" INFO: "+message)
