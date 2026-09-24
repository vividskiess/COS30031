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
	
