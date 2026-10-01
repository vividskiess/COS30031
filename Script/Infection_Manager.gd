extends Node

signal trigger_popup(file_data: FileResource)


#handles Virus injection
var active_virus: Dictionary = {}

func _inject_malware(Virus_class: Script, hidden_name: String, tick_rate: float, target_folder:FileResource = null) -> void:
	var malicious_file = FileResource.new()
	malicious_file.display_name = hidden_name
	malicious_file.file_type = FileResource.FileType.MALICOUS #change to malware type
	
	if target_folder == null:
		target_folder = FileSys.desktop_folder
	
	target_folder.contained_files.append(malicious_file)
	malicious_file.parent_path = target_folder
	
	var virus_node = Virus_class.new()
	add_child(virus_node)
	
	virus_node.setup(malicious_file, target_folder, tick_rate)
	
	RightClickMenu.request_refresh.emit(target_folder)
	active_virus[malicious_file] = virus_node
	
func attempt_containment(target_file: FileResource, duration: float) -> bool:
	if active_virus.has(target_file):
		print("test")
		var virus_script = active_virus[target_file]
		virus_script.contained(duration)
		return true
	else:
		return false
		
