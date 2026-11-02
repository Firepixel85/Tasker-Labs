class_name Date
extends RefCounted

const DAY_NAMES: Array[String] = [
	"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
]
const MONTH_NAMES: Array[String] = [
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"
]

var _day: int = 1
var _month: int = 1
var _year: int = 1970

var day: int:
	get = get_day, set = set_day
var month: int:
	get = get_month, set = set_month
var year: int:
	get = get_year, set = set_year

func _init(p_day: int = 1, p_month: int = 1, p_year: int = 1970) -> void:
	if not is_valid(p_day, p_month, p_year):
		push_error("Date: invalid date %d/%d/%d, keeping %d/%d/%d" % [
			p_day, p_month, p_year, _day, _month, _year
		])
		return
	_day = p_day
	_month = p_month
	_year = p_year

func get_day() -> int:
	return _day

func get_month() -> int:
	return _month

func get_year() -> int:
	return _year

func set_day(value: int) -> void:
	if not is_valid(value, _month, _year):
		push_error("Date: day %d is invalid for %d/%d, keeping %d" % [value, _month, _year, _day])
		return
	_day = value

func set_month(value: int) -> void:
	if not is_valid(_day, value, _year):
		push_error("Date: month %d is invalid for day %d of year %d, keeping %d" % [value, _day, _year, _month])
		return
	_month = value

func set_year(value: int) -> void:
	if not is_valid(_day, _month, value):
		push_error("Date: year %d is invalid for %d/%d, keeping %d" % [value, _day, _month, _year])
		return
	_year = value

func get_month_name() -> String:
	return MONTH_NAMES[_month - 1]

func get_day_name() -> String:
	# 1970-01-01 (day 0) was a Thursday, which is index 4 with Sunday = 0.
	return DAY_NAMES[posmod(_to_days() + 4, 7)]

func is_before(date: Date) -> bool:
	if date == null:
		push_error("Date.is_before(): date is null")
		return false
	return _to_days() < date._to_days()

func is_after(date: Date) -> bool:
	if date == null:
		push_error("Date.is_after(): date is null")
		return false
	return _to_days() > date._to_days()

func is_prev_of(date: Date) -> bool:
	if date == null:
		push_error("Date.is_prev_of(): date is null")
		return false
	return date._to_days() - _to_days() == 1

func is_next_of(date: Date) -> bool:
	if date == null:
		push_error("Date.is_next_of(): date is null")
		return false
	return _to_days() - date._to_days() == 1

static func is_leap_year(p_year: int) -> bool:
	return (p_year % 4 == 0 and p_year % 100 != 0) or p_year % 400 == 0

static func get_days_in_month(p_month: int, p_year: int) -> int:
	match p_month:
		1, 3, 5, 7, 8, 10, 12:
			return 31
		4, 6, 9, 11:
			return 30
		2:
			return 29 if is_leap_year(p_year) else 28
	return 0

func is_same_as(date:Date) -> bool:
	return  _day == date.get_day() and _month == date.get_month() and _year == date.get_year()

func get_next() -> Date:
	if _day < get_days_in_month(_month, _year):
		return Date.new(_day + 1, _month, _year)
	if _month < 12:
		return Date.new(1, _month + 1, _year)
	return Date.new(1, 1, _year + 1)
 
func get_prev() -> Date:
	if _day > 1:
		return Date.new(_day - 1, _month, _year)
	if _month > 1:
		return Date.new(get_days_in_month(_month - 1, _year), _month - 1, _year)
	if _year > 1:
		return Date.new(31, 12, _year - 1)
	push_error("Date.get_prev(): no date exists before 01/01/0001")
	return null

static func is_valid(p_day: int, p_month: int, p_year: int) -> bool:
	if p_year < 1 or p_month < 1 or p_month > 12:
		return false
	return p_day >= 1 and p_day <= get_days_in_month(p_month, p_year)

func _to_days() -> int:
	var y := _year - (1 if _month <= 2 else 0)
	var era := floori(y / 400.0)
	var yoe := y - era * 400
	var mp := (_month + 9) % 12  # March = 0 ... February = 11
	@warning_ignore("integer_division")
	var doy := (153 * mp + 2) / 5 + _day - 1
	@warning_ignore("integer_division")
	var doe := yoe * 365 + yoe / 4 - yoe / 100 + doy
	return era * 146097 + doe - 719468

func _to_string() -> String:
	return "%02d/%02d/%04d" % [_day, _month, _year]
