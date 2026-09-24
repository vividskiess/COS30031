extends Control

@onready var textbox = $Label

func setup(text_data: FileResource) -> void:
	textbox.text = text_data.text_content
