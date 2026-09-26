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
	#desktop_folder = FileResource.new()
	#desktop_folder.display_name = "Desktop"
	#desktop_folder.file_type = FileResource.FileType.FOLDER
	#
	#var path = "res://Asset/Computer_Architecture/Desktop/"
	#var file_names = ResourceLoader.list_directory(path)
	#
	#for file_name in file_names:
		#var full_path = path.path_join(file_name)
		#var load_res = load(full_path)
	#
		#if load_res is FileResource:
			#load_res.parent_path = desktop_folder
			#desktop_folder.contained_files.append(load_res)
	
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
	
	
