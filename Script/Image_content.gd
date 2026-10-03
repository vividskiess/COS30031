extends Node

@onready var image = $TextureRect

var current_file: FileResource

func setup(image_data: FileResource) -> void:
	var current_image = image_data
	
	image.texture = current_image.image_content
	
