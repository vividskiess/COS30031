extends Control

@export var window_scene: PackedScene
@export var desktop_files: Array[FileResource] = []
@export var grid_column: int = 1

@onready var icon_grid: GridContainer = $IconGrid
@onready var taskbar: HBoxContainer = $Taskbar
@onready var background_taskbar: Panel = get_tree().get_first_node_in_group("task_bar_background") 



#Window node -> Button
var minimize_icon_to_window: Dictionary = {}
var background_task_bar_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_preload_desktop("res://Asset/Desktop/")
	_icon_grid_setup()
	
	for file_res in desktop_files:
		create_desktop_icon(file_res, icon_grid)

#Changing grid
func _icon_grid_setup() -> void:
	icon_grid.columns = grid_column
	icon_grid.add_theme_constant_override("h_separation", 100)
	icon_grid.add_theme_constant_override("v_separation",100)

#setting up folder grid 
func _folder_grid_setup(folder:Node) -> void:
	
	pass
	
	
#intiate desktop
func create_desktop_icon(data: FileResource, parent_grid: GridContainer) -> void:
	var icon_instance = preload("res://Objects/Desktop_Icon.tscn").instantiate() #loadup all the icon on the computer
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
	taskbar_button.custom_minimum_size = Vector2(40,40)
	taskbar.add_child(taskbar_button)
	
	#dictionary of button icon
	minimize_icon_to_window[new_window] = taskbar_button
	
	taskbar_button.pressed.connect(func(): _control_window_state(new_window, "open")) #calling to open back up
	
	match data.file_type:
		FileResource.FileType.TEXT:
			var text_label = Label.new()
			text_label.text = data.text_content
			new_window.embed_content(text_label)
			
		FileResource.FileType.FOLDER:
			var folder_grid = GridContainer.new()
			folder_grid.columns = grid_column
			new_window.embed_content(folder_grid)
			for child_file in data.contained_files:
				create_desktop_icon(child_file, folder_grid)
				
#Control if window is changign size close or minimize
func _control_window_state(window_node:Node, new_state:String) -> void:
	match new_state:
		"closed":
			window_node.queue_free()
		"minimized":
			window_node.hide()

#load up all icon in desktop like windows
func _preload_desktop(path: String) -> void:
	
	var  file_name = ResourceLoader.list_directory(path)
	
	for file_names in file_name:
		var full_path = path.path_join(file_names)
		var load_res = load(full_path)
		
		if load_res is FileResource:
			desktop_files.append(load_res)
			
func _task_bar_setup(new_pos: Vector2) -> void:
	background_task_bar_position = new_pos
	taskbar.global_position = background_task_bar_position
	pass
	
func _minimize_to_point() -> void:
	
	pass
		
