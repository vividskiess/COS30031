extends Control

@export var window_scene: PackedScene
@export var desktop_icon: PackedScene
@export var folder_scence: PackedScene
@export var text_scence: PackedScene

#export var application_scence: PackedScence?

@onready var desktop_files: Array[FileResource] = []
@onready var grid_column: int = 4
@onready var Taskbar_grid: int = 5

@onready var icon_grid: GridContainer = $IconGrid
@onready var taskbar_grid = $Taskbar/Panel/TaskbarGrid

signal windows_content(window_node: Node)

#Window node -> Button
var minimize_icon_to_window: Dictionary = {}

#Default Desktop Directory
var desktop_path: String = "C:/Desktop"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_preload_desktop("res://Asset/Desktop/")
	_icon_grid_setup()
	
	for file_res in desktop_files:
		if file_res.file_type == FileResource.FileType.FOLDER:
			link_to_parent(file_res)
	for file_res in desktop_files:
		create_desktop_icon(file_res, icon_grid)


#Changing grid main window
func _icon_grid_setup() -> void:
	#Desktop_grid seperation
	icon_grid.columns = grid_column
	icon_grid.add_theme_constant_override("h_separation", 100)
	icon_grid.add_theme_constant_override("v_separation",100)
	
	#icon_grid seperation
	taskbar_grid.add_theme_constant_override("h_separation", 50)


#linking every folder
func link_to_parent(parent: FileResource):
	for child in parent.contained_files:
		child.parent_path = parent
		if child.file_type == FileResource.FileType.FOLDER:
			link_to_parent(child)
	
	
#intiate desktop
func create_desktop_icon(data: FileResource, parent_grid: GridContainer) -> void:
	var icon_instance = desktop_icon.instantiate() #loadup all the icon on the computer
	parent_grid.add_child(icon_instance)
	icon_instance.setup(data)
	icon_instance.icon_double_clicked.connect(_on_icon_open)
	
	
#Opening Window Scence
func _on_icon_open(data: FileResource) -> void:
	var new_window = window_scene.instantiate()
	add_child(new_window)
	new_window.set_title(data.display_name)
	new_window.state.connect(_control_window_state) #connects with window to change open, close. minimize
	
	
	#creating mini button in taskbar
	var taskbar_button = Button.new()
	taskbar_button.icon = data.icon_texture
	taskbar_button.custom_minimum_size = Vector2(64,64) #size of icon in minimize mode
	taskbar_button.position.x = 120
	taskbar_grid.add_child(taskbar_button)
	
	
	
	#dictionary of button icon
	minimize_icon_to_window[new_window] = taskbar_button
	taskbar_button.pressed.connect(func(): _control_window_state(new_window, "opened")) #calling to open back up
	
	
	#to be moved to Each of thier own
	match data.file_type:
		FileResource.FileType.TEXT:
			#open Text Scence
			var text_content = text_scence.instantiate()
			new_window.embed_content(text_content)
			text_content.setup(data)


			
		FileResource.FileType.FOLDER:
			#Open folder Scence
			var folder_content = folder_scence.instantiate()
			new_window.embed_content(folder_content)
			#changing folder name without creating new scnce
			folder_content.change_window_name.connect(func(file_data): new_window.set_title(file_data.display_name))
			folder_content.open_new_window.connect(_on_icon_open)
			
			folder_content.setup(data, "C:/Desktop/")
				
#Control if window is changign size close or minimize
func _control_window_state(window_node:Node, new_state:String) -> void:
	match new_state:
		"closed":
			if minimize_icon_to_window.has(window_node):
				var icon_button = minimize_icon_to_window[window_node]
				icon_button.queue_free()
				minimize_icon_to_window.erase(window_node)
			
			window_node.queue_free()
			
		"minimized":
			if minimize_icon_to_window.has(window_node):
				var icon_button = minimize_icon_to_window[window_node]
				window_node._minimize_to_point(icon_button.global_position)
			
		"opened":
				window_node.show()
				window_node.move_to_front()
				

	

#load up all icon in desktop like windows
func _preload_desktop(path: String) -> void:
	
	var  file_name = ResourceLoader.list_directory(path)
	
	for file_names in file_name:
		var full_path = path.path_join(file_names)
		var load_res = load(full_path)
		
		if load_res is FileResource:
			desktop_files.append(load_res)
	

		
