extends Node

const HOME = preload("res://Icons/Home.svg")
const BOOK = preload("res://Icons/Book.svg")
const CHECKLIST = preload("res://Icons/Checklist.svg")
const TRASH = preload("res://Icons/Trash.svg")
const PREVIOUS = preload("res://Icons/Previous.svg")
const NEXT = preload("res://Icons/Next.svg")
const SCISSORS = preload("res://Icons/Scissors.svg")
const UP = preload("res://Icons/Up.svg")
const DOWN = preload("res://Icons/DOWN.svg")

func get_icon(icon_name:String):
	return load("res://Icons/"+icon_name+".svg")
