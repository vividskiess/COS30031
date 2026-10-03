extends Control

signal finsih_scan(threat: Array[FileResource])

func start_scan(target_folder: FileResource) -> void:
	
	var all_file = FileSys.get_all_file_in_folder_for_scan(target_folder)
	var found_virus: Array[FileResource] = []
	for file in all_file:
		if file.is_infected:
			found_virus.append(file)
	
	finsih_scan.emit(found_virus)
	queue_free()
	
			
	
			
			
