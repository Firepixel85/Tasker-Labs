extends Control

var iscreating:bool #Is the New Task Scene Active?
var justcreatedid:int #The ID of the task that was just created
var loadcreationstatus:int = -1  #On load -1 Isn't loading 0 Is loading 1 Done loading
var isloading:bool
var lastgivenid:int 
var namedic:Dictionary
var colordic:Dictionary
var icondic:Dictionary
var donedic:Dictionary
var streakdic:Dictionary
