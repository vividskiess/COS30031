extends PopupMenu

signal request_refresh(modified_file: FileResource) #change to file creation
signal request_rename
signal request_virus_scan(target_folder: FileResource)
signal request_contain(target_file: FileResource)
signal reverse_engineer(target_file: FileResource)

var current_dir: FileResource
var target_file:FileResource = null

var rect_size_x = 500
var rect_size_y = 100

var sub_menu: PopupMenu
var is_cut_used = false



enum PopupIds{
	new,
	rename,
	copy,
	cut,
	paste,
	scanner, 
	container,
	Reverse_Engineer,
}

enum CreateMenu{
	text,
	folder
}

func _ready():
	#Sub Menu for file creation
	sub_menu = PopupMenu.new()
	sub_menu.name = "NewSubMenu"
	add_child(sub_menu)
	
	#Main Right Click menu adding option
	add_submenu_node_item("New", sub_menu) #Done
	add_item("Rename", PopupIds.rename) #Done
	add_item("Copy", PopupIds.copy) #Done
	add_item("Cut", PopupIds.cut) #Work in progress
	add_item("Paste", PopupIds.paste) #Done
	add_item("Scanner", PopupIds.scanner) #Done
	add_item("Contain", PopupIds.container) #Work in progress
	add_item("Reverse Engineer", PopupIds.Reverse_Engineer ) #Andrew

	#sub menu adding 
	sub_menu.add_item("Folder", CreateMenu.folder)
	sub_menu.add_item("Text", CreateMenu.text)
	
	id_pressed.connect(_on_item_pressed)
	sub_menu.id_pressed.connect(_on_new_sub_menu_pressed)
	

func _open_menu(dir: FileResource, spawn_pos: Vector2, file: FileResource = null) -> void: #create the meny
	current_dir = dir
	target_file = file
	position = spawn_pos
	popup(Rect2(spawn_pos.x, spawn_pos.y, rect_size_x, rect_size_y))


func _on_item_pressed(id: int) -> void:
	match id:
		PopupIds.rename:
			request_rename.emit()
		PopupIds.copy:
			if target_file != null:
				print("Copy")
				FileSys.copy_file(target_file)
				print("Copied" + target_file.display_name) #testing
		PopupIds.paste:
			print("Paste")
			FileSys.paste_file(current_dir)
			request_refresh.emit(current_dir)	
		PopupIds.scanner:
			if target_file != null and target_file.file_type == FileResource.FileType.FOLDER:
				request_virus_scan.emit(target_file)
			else:
				request_virus_scan.emit(current_dir)
				
		PopupIds.container:
				request_contain.emit(target_file)	
				
		PopupIds.Reverse_Engineer:
			if target_file.is_infected == true:
				reverse_engineer.emit(target_file)
			

func _on_new_sub_menu_pressed(id: int) -> void:
	match id:
		CreateMenu.folder:
			FileSys.create_file(current_dir, "New Folder", FileResource.FileType.FOLDER)
			request_refresh.emit(current_dir)
		CreateMenu.text:
			FileSys.create_file(current_dir, "New Folder", FileResource.FileType.TEXT)
			request_refresh.emit(current_dir)
			
