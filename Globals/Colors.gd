extends Node

const GRAY_HIGHLIGHT = Color("414141")
const WHITE_HIGHLIGHT = Color("DADADA")
const RED_HIGHLIGHT = Color("E74747")
const ORANGE_HIGHLIGHT = Color("FBA051")
const YELLOW_HIGHLIGHT = Color("FFDC58")
const GREEN_HIGHLIGHT = Color("4BF14F")
const TEAL_HIGHLIGHT = Color("8FFFF2")
const BLUE_HIGHLIGHT = Color("4B9CED")
const PINK_HIGHLIGHT = Color("FF85C4")
const PURPLE_HIGHLIGHT = Color("935CF7")

const GRAY = "Gray"
const WHITE = "White"
const RED = "Red"
const ORANGE = "Orange"
const YELLOW = "Yellow"
const GREEN = "Green"
const TEAL = "Teal"
const BLUE = "Blue"
const PINK = "Pink"
const PURPLE = "Purple"

const COLOR_NORMAL = Color(1,1,1)
const _COLOR_PRESSED = Color(0.65,0.65,0.65)
const _COLOR_HOVERED = Color(0.85,0.85,0.85)
const _COLOR_DISABLED = Color(0.6,0.6,0.6)
const _COLOR_DISABLED_HOVERED = Color(0.55,0.55,0.55)

func verify_color(color:String):
	match color:
		GRAY,WHITE,RED,ORANGE,YELLOW,GREEN,TEAL,BLUE,PINK,PURPLE:
			return OK
		_:
			return Error.ERR_INVALID_PARAMETER
