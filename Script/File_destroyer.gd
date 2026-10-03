class_name file_eater extends Base_malware

func cause_symptom() -> void:
	var all_files = FileSys._get_all_files(FileSys.desktop_folder)
	
	if all_files.has(Host_file):
		all_files.erase(Host_file)
	
	if all_files.size() > 0:
		var target = all_files.pick_random()
		
		if target.is_infected != true && target.file_type != FileResource.FileType.FOLDER:
			target.parent_path.contained_files.erase(target)
		
		RightClickMenu.request_refresh.emit(target.parent_path)
