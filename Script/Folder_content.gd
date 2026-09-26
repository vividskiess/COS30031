extends Control

@export var icon_scence: PackedScene #desktop_Icon

signal open_new_window(file_data: FileResource)
signal change_window_name(file_data: FileResource)

@onready var folder_grid = $Content_container
@onready var back_button = $Back
@onready var forward_button = $Forward
@onready var directory_bar = $Directory_display

#current folder position (Opened by the user)
var current_folder = FileResource

var folder_column = 7 #folder grid
var base_path : String = "" #building directory
var is_selected: FileResource = null #selected file

#keep track of every folder list
var back_history: Array[FileResource] = []
var forward_history: Array[FileResource] = []
	
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
	_grid_setup() #folder grid
	RightClickMenu.request_refresh.connect(_on_menu_refresh)
	RightClickMenu.request_rename.connect(_on_menu_rename_request)
	
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_selected = null
			_deselect_all_icon()
			
		if event.button_index == MOUSE_BUTTON_RIGHT:
			RightClickMenu._open_menu(current_folder, get_global_mouse_position(),  null)


func _deselect_all_icon() -> void:
	for child in folder_grid.get_children():
		if child.has_method("deselect"):
			child.deselect()
	
func _grid_setup() -> void: #folder adjustment
	folder_grid.columns = folder_column
	folder_grid.add_theme_constant_override("h_separation", 100)

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
		icon.icon_selected.connect(_on_selected_icon)

func _on_folder_clicked(file_data: FileResource) -> void:
	
	if file_data.file_type == FileResource.FileType.FOLDER:
		back_history.append(current_folder)
		forward_history.clear() #clear any forward movement
		_load_folder(file_data)
	
	else:
		open_new_window.emit(file_data)
		
func _on_selected_icon(Selecteddata: FileResource) -> void:
	is_selected = Selecteddata
	
	for child in folder_grid.get_children():
		if child.has_method("deselect") and child.file_data != is_selected:
			child.deselect()
		
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
		
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is FileResource

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var old_folder = data.parent_path
	var new_folder = current_folder
	FileSys.move_file(data, old_folder, new_folder)
	_refresh_grid()
	get_tree().reload_current_scene() #reload scence for folder
	
func _refresh_grid() -> void:
	if current_folder != null:
		_load_folder(current_folder)
		
		
		
func _on_menu_refresh(modified_folder: FileResource)->void:
	if modified_folder == current_folder:
		_refresh_grid()
		
		await get_tree().process_frame
		
		var icons = folder_grid.get_children()
		if icons.size() > 0:
			var new_icon = icons[-1]
			if new_icon.has_method("_start_renaming"):
				new_icon._start_renaming()
				
func _on_menu_rename_request() -> void:
	if is_selected != null:
		
		for child in folder_grid.get_children():
			if child.file_data == is_selected:
				if child.has_method("_start_renaming"):
					child._start_renaming(	)
					
				
