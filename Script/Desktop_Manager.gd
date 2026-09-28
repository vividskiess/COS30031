extends Control

@export var window_scene: PackedScene
@export var desktop_icon: PackedScene
@export var folder_scence: PackedScene
@export var text_scence: PackedScene
@export var scanner_scence: PackedScene

@export var remediate: PackedScene


#export var application_scence: PackedScence?

@onready var desktop_files: Array[FileResource] = []
@onready var icon_grid: GridContainer = $IconGrid
@onready var taskbar_grid = $Taskbar/Panel/TaskbarGrid
@onready var clock = $Taskbar/Panel/TaskbarGrid/Time/Label

#Window node -> Button
var minimize_icon_to_window: Dictionary = {}

#to be changed to array to be used as multiple select
var is_selected: FileResource = null

var desktop_folder : FileResource

#testing grid
var grid_column: int = 4
var Taskbar_grid: int = 5

func _testing_timer() -> void:
	print("Test clock")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_icon_grid_setup()
	
	desktop_folder = FileSys.desktop_folder
	
	link_to_parent(desktop_folder)
	
	_refresh_grid()
	
	
	RightClickMenu.request_refresh.connect(_on_menu_request)
	RightClickMenu.request_rename.connect(_on_menu_rename_request)
	RightClickMenu.request_virus_scan.connect(_on_virus_scan_request)
	
	Clock.time_passed.connect(_clock_update)
	Clock.game_over_signal.connect(_handle_game_state)
	#
	InfectionManager._inject_malware(Rename_Virus, "NotSus", 2)
	InfectionManager._inject_malware(Rename_Virus, "NotSus", 2)
	#InfectionManager._inject_malware(Rename_Virus, "NotSus", 2)
	#InfectionManager._inject_malware(Rename_Virus, "NotSus", 2)
	
		
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_selected = null
			
		_deselect_all_icon()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			RightClickMenu._open_menu(desktop_folder, get_global_mouse_position(), null)
			

func _deselect_all_icon() -> void:
	for child in icon_grid.get_children():
		if child.has_method("deselect"):
			child.deselect()


#Changing grid main window
func _icon_grid_setup() -> void:
	#Desktop_grid sepeartion
	
	icon_grid.columns = grid_column
	icon_grid.add_theme_constant_override("h_separation", 150)
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
	icon_instance.icon_selected.connect(_on_icon_selected)
	
	
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
				
				
func _on_icon_selected(selectedData: FileResource) -> void:
	is_selected = selectedData
	
	for child in icon_grid.get_children():
		if child.has_method("deselect") and child.file_data != selectedData:
			child.deselect()

func _refresh_grid() -> void:
	for child in icon_grid.get_children():
		child.queue_free()
	
	for file_res in desktop_folder.contained_files:
		create_desktop_icon(file_res, icon_grid)
		
func _on_menu_request(modified_folder: FileResource)->void:
	if modified_folder == desktop_folder:
		_refresh_grid()
		await get_tree().process_frame

func _on_menu_rename_request() -> void:
	if is_selected != null:
		
		for child in icon_grid.get_children():
			if child.file_data == is_selected:
				if child.has_method("_start_renaming"):
					child._start_renaming(	)
					
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	#if data != self:
	return data is FileResource
	#return false

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var old_folder = data.parent_path
	var new_folder = desktop_folder
	FileSys.move_file(data, old_folder, new_folder)
	_refresh_grid()
	RightClickMenu.request_refresh.emit(old_folder)
	
func _on_virus_scan_request(file: FileResource) -> void:
	var Scanner = scanner_scence.instantiate()
	add_child(Scanner)
	
	if Scanner.has_method("_Search_infected_files"):
		Scanner._Search_infected_files(file)
		
	
	pass
	
	
func _clock_update(hours: int, minute:int) -> void:
	var time_string = "%02d:%02d" % [hours, minute] 
	clock.text = time_string
	
func _handle_game_state(game_state: bool) -> void:
	#print("Game Over")
	pass
