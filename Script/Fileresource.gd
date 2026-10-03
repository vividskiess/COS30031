class_name FileResource
extends Resource

#Todo File type checking for Directory

enum FileType {FOLDER, TEXT, IMAGE, EXECUTABLE, MALICOUS, GAME_ASSET}

@export var display_name: String = "New File"
@export var icon_texture: Texture2D
@export var image_content: Texture2D
@export var file_type: FileType = FileType.TEXT
@export var is_infected: bool = false


@export_multiline var text_content: String = "" #Notepad
@export var contained_files: Array[FileResource] #Folder
var parent_path: FileResource = null #file path for all parent and child links
