class_name JsonSyntaxHighlighter
extends SyntaxHighlighter
## JSON syntax highlighter for CodeEdit / TextEdit.
## Default colors follow the GitHub Dark palette (designed for a #0d1117
## background).
##
## Colors object keys differently from string values, and also highlights
## numbers, true/false/null, punctuation, escape sequences (\n, \u00e9, ...)
## and invalid tokens.
##
## Usage:
##     $CodeEdit.syntax_highlighter = JsonSyntaxHighlighter.new()

@export var default_color := Color("#e6edf3"):
	set(value):
		default_color = value
		clear_highlighting_cache()
@export var key_color := Color("#7ee787"): # green
	set(value):
		key_color = value
		clear_highlighting_cache()
@export var string_color := Color("#a5d6ff"): # light blue
	set(value):
		string_color = value
		clear_highlighting_cache()
@export var escape_color := Color("#ffa657"): # orange
	set(value):
		escape_color = value
		clear_highlighting_cache()
@export var number_color := Color("#79c0ff"): # blue
	set(value):
		number_color = value
		clear_highlighting_cache()
@export var keyword_color := Color("#ff7b72"): # true / false / null (coral)
	set(value):
		keyword_color = value
		clear_highlighting_cache()
@export var symbol_color := Color("#c9d1d9"): # { } [ ] , :
	set(value):
		symbol_color = value
		clear_highlighting_cache()
@export var error_color := Color("#f85149"): # red
	set(value):
		error_color = value
		clear_highlighting_cache()

const _KEYWORDS := ["true", "false", "null"]
const _NUMBER_CHARS := "0123456789+-.eE"
const _SYMBOLS := "{}[],:"


func _get_line_syntax_highlighting(line: int) -> Dictionary:
	var result := {}
	var text_edit := get_text_edit()
	if text_edit == null:
		return result

	var text := text_edit.get_line(line)
	var length := text.length()
	result[0] = {"color": default_color}

	var i := 0
	while i < length:
		var c: String = text[i]

		if c == " " or c == "\t":
			i += 1
		elif c == "\"":
			var end := _find_string_end(text, i)
			var next := _skip_whitespace(text, end)
			var is_key := next < length and text[next] == ":"
			_highlight_string(text, i, end, key_color if is_key else string_color, result)
			i = end
		elif c == "-" or (c >= "0" and c <= "9"):
			result[i] = {"color": number_color}
			i += 1
			while i < length and _NUMBER_CHARS.contains(text[i]):
				i += 1
		elif _is_letter(c):
			var start := i
			while i < length and _is_letter(text[i]):
				i += 1
			var word := text.substr(start, i - start)
			result[start] = {"color": keyword_color if word in _KEYWORDS else error_color}
		elif _SYMBOLS.contains(c):
			result[i] = {"color": symbol_color}
			i += 1
		else:
			result[i] = {"color": error_color}
			i += 1

	return result


## Returns the index just past the closing quote, or the line length if the
## string is unterminated. [param start] must point at the opening quote.
func _find_string_end(text: String, start: int) -> int:
	var i := start + 1
	while i < text.length():
		var c: String = text[i]
		if c == "\\":
			i += 2
			continue
		if c == "\"":
			return i + 1
		i += 1
	return text.length()


## Colors the string [start, end) and gives escape sequences their own color.
func _highlight_string(text: String, start: int, end: int, color: Color, result: Dictionary) -> void:
	var length := text.length()
	result[start] = {"color": color}
	var i := start + 1
	while i < end:
		if text[i] == "\\":
			var escape_length := 6 if (i + 1 < length and text[i + 1] == "u") else 2
			var escape_end := mini(i + escape_length, end)
			result[i] = {"color": escape_color}
			if escape_end < length:
				result[escape_end] = {"color": color}
			i = escape_end
		else:
			i += 1


func _skip_whitespace(text: String, from: int) -> int:
	var i := from
	while i < text.length() and (text[i] == " " or text[i] == "\t"):
		i += 1
	return i


func _is_letter(c: String) -> bool:
	return (c >= "a" and c <= "z") or (c >= "A" and c <= "Z")
