extends Node

var clock_tick_rate: float = 60.0 #speed up or slow down (60 is to say 1s real time turn to 1 min in game)
var elapsed_time: float = 0.0

var current_min: float = 0.0
var current_hour: float = 0.0

var game_over = false
var starting_hour = 9

signal time_passed(current_hour:int, current_minute:int)
signal game_over_signal(game_state: bool)

func _process(delta: float) -> void:
	elapsed_time += delta * clock_tick_rate
	
	var total_min = int(elapsed_time/60.0)
	
	var new_minute = total_min % 60
	var new_hour = (starting_hour + (total_min/60)) % 24 
	
	#_check_gameover()
	
	if new_minute != current_min and game_over != true:
		current_min = new_minute
		current_hour = new_hour
		time_passed.emit(current_hour, current_min)
	
func _check_gameover() -> void:

	if current_hour == 10.0:
		game_over = true
		game_over_signal.emit(game_over)
		

	
		
