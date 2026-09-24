extends Control

@export var icon_scence: PackedScene #desktop_Icon

signal open_new_window(file_data: FileResource)
signal change_window_name(file_data: FileResource)

@onready var folder_grid = $Content_container
@onready var back_button = $Back
@onready var forward_button = $Forward
@onready var directory_bar = $Directory_display

#current folder position (Opened by the user)
var current_folder: FileResource

var base_path : String = ""


#keep track of every folder list
var back_history: Array[FileResource] = []
var forward_history: Array[FileResource] = []

#work in progress
func _create_new_file() -> void:
	pass
	
func _update_bar_path()->void:
	if current_folder == null:
		return
	
	var path_string = current_folder.display_name
	var current_node = current_folder.parent_path
	
	while current_node != null:
		path_string = current_node.display_name + "/" + path_string
		
		#moving up the link
		current_node = current_node.parent_path
		
	directory_bar.text = "C:/" + path_string
	
func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	forward_button.pressed.connect(_on_forward_button_pressed)

func setup(folder_data: FileResource, starting_path: String) -> void:
	base_path = starting_path
	_load_folder(folder_data)
		
		
func _load_folder(new_folder: FileResource) -> void:
	current_folder = new_folder
	
	back_button.disabled = back_history.is_empty() #check if no history cant turn back same applied for forward
	forward_button.disabled = forward_history.is_empty()# check if history in front
	
	_update_bar_path()

	change_window_name.emit(current_folder)
	#clear out any old icon
	for child in folder_grid.get_children():
		child.queue_free()
	
	#create new children
	for file in current_folder.contained_files:
		var icon = icon_scence.instantiate()
		folder_grid.add_child(icon)
		icon.setup(file)
	
		icon.icon_double_clicked.connect(_on_folder_clicked)

func _on_folder_clicked(file_data: FileResource) -> void:
	if file_data.file_type == FileResource.FileType.FOLDER:
		back_history.append(current_folder)
		forward_history.clear() #clear any forward movement
		_load_folder(file_data)
	
	else:
		open_new_window.emit(file_data)
		
#Bi-directional Linked list to keep track of folder and position
func _on_back_button_pressed() -> void:
	if back_history.size() > 0:
		forward_history.append(current_folder)
		var previous_folder = back_history.pop_back()
		_load_folder(previous_folder)

func _on_forward_button_pressed() -> void:
	if forward_history.size() > 0:
		back_history.append(current_folder)
		var forward_folder = forward_history.pop_back()
		_load_folder(forward_folder)
	pass
		
	
