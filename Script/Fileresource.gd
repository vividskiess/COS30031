class_name FileResource
extends Resource

#Todo File type checking for Directory

enum FileType {FOLDER, TEXT, IMAGE, EXECUTABLE}


@export var display_name: String = "New File"
@export var icon_texture: Texture2D
@export var file_type: FileType = FileType.TEXT


@export_multiline var text_content: String = "" #Notepad
@export var contained_files: Array[FileResource] #Folder
@export var filepath: String = "" #File Directory


func _get_full_path() -> String:
	return filepath + display_name
