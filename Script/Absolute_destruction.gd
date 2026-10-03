class_name destruction extends Base_malware

var ticks_left: int = 10

func cause_symptom() -> void:
	ticks_left -= 1
	
	if ticks_left <= 0:
		Clock.game_over_signal.emit(false)
	else:
		Host_file.display_name = "System Failure IN " + str(ticks_left)
		RightClickMenu.request_refresh.emit(Host_file.parent_path)
	pass
