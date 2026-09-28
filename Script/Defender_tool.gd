extends Control

@onready var Res = $Label

func _Search_infected_files(Scanned_file: FileResource) -> void:
	Res.text = "Scanning" + Scanned_file.display_name +"..." 
	
	await get_tree().process_frame
	
	
	var infected_found = 0 #int if number only array if its actual app
	#var infected_file_found: Array[ResourceFile] = []
	var Files_list = FileSys.get_all_file_in_folder_for_scan(Scanned_file)
	
	for item in Files_list:
		if item.is_infected == true:
			infected_found += 1
	
	Res.text = "Malware found:" + str(infected_found)
	
	print("Suc")
