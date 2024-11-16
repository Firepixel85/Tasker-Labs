extends Control

var iscreating:bool #Is the New Task Scene Active?
var justcreatedid:int #The ID of the task that was just created
var loadcreationstatus:int = -1  #On load: -1 Isn't loading 0 Is loading 1 Done loading
var isloading:bool
var lastgivenid:int 

#Overview
var justcreatedid_overview:int
var loadcreationstatus_overview:int = -1

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

#Orientation
var orientationcomp:bool
var timesetting:int = 0
var username:String 

#Settings
var issetting:bool
var settings:Dictionary = {"time_setting":0,"username":"","sidebar_selection":0,"sb_selection_color":"8667E9","use_h_dpi":true}

var production:bool = true
