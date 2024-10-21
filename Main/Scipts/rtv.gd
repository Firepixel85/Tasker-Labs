extends Control

var iscreating:bool #Is the New Task Scene Active?
var justcreatedid:int #The ID of the task that was just created
var loadcreationstatus:int = -1  #On load: -1 Isn't loading 0 Is loading 1 Done loading
var isloading:bool
var lastgivenid:int 

#Log Control:
var lastlogd #Last logged date detected by the runtime
var lastlogwasloaded:bool #Were the lastlog vars loaded?
var streakstatus:String #On run: "hold" can obtain streak "same" can obtain "kill" all streaks lost

#Editing 
var isediting:bool
var edittarget:String
var deletetarget:String
var namedic:Dictionary
var iddic:Dictionary
var colordic:Dictionary
var icondic:Dictionary
var donedic:Dictionary
var streakdic:Dictionary
var comlastlogdic:Dictionary

var production:bool = true
