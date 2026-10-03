extends Control

const DAYS := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
const MONTHS := ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]


func _ready() -> void:
	_update_clock()


func _update_clock() -> void:
	var now := Time.get_datetime_dict_from_system()
	var hour: int = now.hour % 12
	if hour == 0:
		hour = 12
	%Time.text = "%d:%02d" % [hour, now.minute]
	%Date.text = "%s %d %s" % [DAYS[now.weekday], now.day, MONTHS[now.month - 1]]
