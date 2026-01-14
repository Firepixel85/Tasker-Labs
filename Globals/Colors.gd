extends Node

const gray := Color(0.114, 0.114, 0.114)
const green := Color(0.165, 0.839, 0.18)
const red := Color(0.843, 0.176, 0.173)
const blue := Color(0.224, 0.576, 0.925)
const accent := Color(0.478, 0.247, 0.906)
const white := Color(1,1,1)

const colors = [
	gray,
	green,
	red,
	blue,
	accent,
	white
]

enum ColorEnum {
	Gray=0,
	Green=1,
	Red=2,
	Blue=3,
	Accent=4,
	White=5
}

func get_color(color:String):
	if color == "gray" or color == "Gray":
		return gray
	elif color == "green" or color == "Green":
		return green
	elif color == "red" or color == "Red":
		return red
	elif color == "blue" or color == "Blue":
		return blue
	elif color == "accent" or color == "Accent":
		return accent
	elif color == "white" or color == "White":
		return white
