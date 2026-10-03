extends Control

@onready var Writting_text = $Text_edit

var current_file: FileResource

func setup(text_data: FileResource) -> void:
	current_file = text_data
	
	Writting_text.text = current_file.text_content
	
	Writting_text.text_changed.connect(_changed_text)

	
func _changed_text() -> void:
	if current_file != null:
		current_file.text_content = Writting_text.text


	
