extends Node

#Format {"Path/String":[FileResource1, FileResource2]}???

var dictionary : Dictionary = {
	"C:/Desktop":[],
	"C:/Documents":[],
	"C:/System":[]
}

func add_path(path:String, new_file:FileResource) -> void:
	if not dictionary.has(path):
		dictionary[path] = []
	
	dictionary[path].append(new_file)
	
	
	
func get_file_in_folder(path:String) -> Array:
	if dictionary.has(path):
		return dictionary[path]
	return []

func move_file(file: FileResource, old_folder: FileResource, new_folder:FileResource) -> void:
	old_folder.contained_files.erase(file)
	new_folder.contained_files.append(file)
	file.parent_path = new_folder

func create_file(parent_dir: FileResource, new_name:String, type:int) -> void:
	var newfile = FileResource.new()
	newfile.display_name = new_name
	newfile.file_type = type
	newfile.parent_path = parent_dir
	
	if type == FileResource.FileType.FOLDER:
		newfile.icon_texture = preload("res://Asset/folder.png")
	if type == FileResource.FileType.TEXT:
		newfile.icon_texture = preload("res://Asset/notes.png")
	
	parent_dir.contained_files.append(newfile)
	
func copy_file() -> void:
	pass

func paste_file() -> void:
	pass
	
