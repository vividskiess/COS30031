class_name Worm extends Base_malware

func cause_symptom() -> void:
	
	var get_all_item = FileSys._get_all_files(FileSys.desktop_folder)
	var all_folders: Array[FileResource] = FileSys._get_all_folder(FileSys.desktop_folder)
	
	var clone_destination = all_folders.pick_random()
	
	InfectionManager._inject_malware(
		get_script(),
		Host_file.display_name,
		sym_timer.wait_time,
		clone_destination
	)
	
