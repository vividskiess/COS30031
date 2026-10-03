extends Node

#handles Virus injection

func _inject_malware(Virus_class: Script, hidden_name: String, tick_rate: float) -> void:
	var malicious_file = FileResource.new()
	malicious_file.display_name = hidden_name
	malicious_file.file_type = FileResource.FileType.TEXT
	
	var target_folder = FileSys.desktop_folder
	target_folder.contained_files.append(malicious_file)
	malicious_file.parent_path = target_folder
	
	var virus_node = Virus_class.new()
	add_child(virus_node)
	
	virus_node.setup(malicious_file, target_folder, tick_rate)
	
	RightClickMenu.request_refresh.emit(target_folder)
