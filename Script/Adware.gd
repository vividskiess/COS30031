class_name AdwareVirus extends Base_malware

func cause_symptom() -> void:
	var popup_data = FileResource.new()
	popup_data.display_name = "Free_Prize_" + str(randi() % 9999) + ".txt"
	popup_data.file_type = FileResource.FileType.TEXT
	popup_data.text_content = "Your Laptop is at Risk download this Anti software"

	InfectionManager.trigger_popup.emit(popup_data)
	
