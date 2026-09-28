class_name Rename_Virus extends Base_malware

func cause_symptom() -> void:
	var all_file = _get_all_files(FileSys.desktop_folder)

	if all_file.has(Host_file): #virus dosent curr itself
		all_file.erase(Host_file)
		
	if all_file.size() > 0:
		var target_file = all_file.pick_random()
		target_file.display_name = "0x" + str(randi() % 9999) + ".CR" #Corrupt name
		
		RightClickMenu.request_refresh.emit(target_file.parent_path)
		
		
func _get_all_files(current_folder: FileResource) -> Array[FileResource]:
	var found_files: Array[FileResource] = []
	
	for item in current_folder.contained_files:
		if item.file_type == FileResource.FileType.FOLDER:
			var sub_folder = _get_all_files(item)
			found_files.append(item)#infect the folder as well :>
			found_files.append_array(sub_folder)
		else:
			found_files.append(item)
		
	return found_files
		
