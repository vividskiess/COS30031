extends Control

@onready var status = $VBoxContainer/VScrollBar/Result
@onready var res_list = $VBoxContainer/Status

func start_scan(target_folder: FileResource) -> void:
	
	status.text = "Scanning " + target_folder.display_name + "..."
	status.modulate = Color.WHITE
	
	for child in res_list.get_children():
		child.queue_free()
		
	await  get_tree().process_frame
	
	var all_file = FileSys.get_all_file_in_folder_for_scan(target_folder)
	var found_virus: Array[FileResource] = []
	
	for file in all_file:
		if file.is_infected:
			found_virus.append(file)
			
	_display_result(found_virus)
			
			
func _display_result(virus: Array[FileResource]) -> void:
	if virus.size() > 0:
		status.text = str(virus.size()) + "Threat Found"
		status.modulate =Color.RED
		
		for v in virus:
			var threat_label = Label.new()
			threat_label.text = v.display_name 
			threat_label.add_theme_color_override("font_color", Color.ORANGE)
			
			res_list.add_child(threat_label)
	else:
		status.text = "System Secure. No threat Found"
		status.modulate = Color.GREEN 
			
