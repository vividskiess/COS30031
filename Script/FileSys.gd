extends Node

var desktop_folder = FileResource
var clipboard: Array[FileResource] = []

var dictionary : Dictionary = {
	"C:/Desktop":[],
	"C:/Documents":[],
	"C:/System":[]
}

func _ready() -> void:
	_intialize_system()

func _intialize_system() -> void:
	desktop_folder = load("res://Asset/Computer_Architecture/Desktop.tres")
	
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

func create_file(parent_dir: FileResource, default_name:String, type:int) -> void:
	var newfile = FileResource.new()
	newfile.display_name = default_name
	newfile.file_type = type
	newfile.parent_path = parent_dir
	
	if type == FileResource.FileType.FOLDER:
		newfile.icon_texture = preload("res://Asset/folder.png")
	if type == FileResource.FileType.TEXT:
		newfile.icon_texture = preload("res://Asset/notes.png")
	
	parent_dir.contained_files.append(newfile)
	
func copy_file(file:FileResource) -> void:
	print("copy from filesys")
	clipboard.clear()
	clipboard.append(file)


func paste_file(target_folder: FileResource)->void:
	if clipboard.is_empty():
		return
	
	print("paste from filesys")
	for file in clipboard:
		var new_file = file.duplicate()
		new_file.parent_path = target_folder
		target_folder.contained_files.append(new_file)
		
#get file in folder
func get_all_file_in_folder_for_scan(current_folder: FileResource) -> Array[FileResource]:
	var found_files: Array[FileResource] = []
	for item in current_folder.contained_files:
		if item.file_type != FileResource.FileType.FOLDER: #ensure its not sending folder as well
			found_files.append(item)
		
	return found_files

#get all of the files
func _get_all_files(current_folder: FileResource) -> Array[FileResource]:
	var found_files: Array[FileResource] = []
	
	for item in current_folder.contained_files:
		if item.file_type == FileResource.FileType.FOLDER:
			var sub_folder = _get_all_files(item)
			found_files.append(item)
			found_files.append_array(sub_folder)
		else:
			found_files.append(item)
		
	return found_files

#get only folder
func _get_all_folder(current_folder: FileResource) -> Array[FileResource]:
	var found_files: Array[FileResource] = []

	for item in current_folder.contained_files:
		if item.file_type == FileResource.FileType.FOLDER:
			var sub_folder = _get_all_files(item)
			found_files.append(item)
		else:
			found_files.append(item)
		
	return found_files
	
	
