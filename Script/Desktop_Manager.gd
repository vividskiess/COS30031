extends Control
#Import all content Nodes for each section {Window, Content, Remediate system}
@export var window_scene: PackedScene
@export var desktop_icon: PackedScene
@export var folder_scence: PackedScene
@export var text_scence: PackedScene
@export var notification_scence: PackedScene
@export var Scanner_scence: PackedScene
@export var remediate_scence: PackedScene


@export var difficulty: int = 3

#singleton Scanner
@onready var active_scanner_window: Node = null
@onready var active_scanner_content: Node = null


#Handles Desktop Load, Icon_grid, Taskbar, computer clock
@onready var desktop_files: Array[FileResource] = []
@onready var icon_grid: GridContainer = $IconGrid
@onready var taskbar_grid = $Taskbar/Panel/TaskbarGrid
@onready var clock = $Taskbar/Panel/TaskbarGrid/Time/Label
@onready var notification_area = $Notifcation_spot

#Window node mapped to button to be open later
var minimize_icon_to_window: Dictionary = {}

#to be changed to array to be used as multiple select but to check which file is looked at
var is_selected: FileResource = null

#Main Desktop
var desktop_folder : FileResource


#testing grid needs to be adjustable later on
var grid_column: int = 4
var Taskbar_grid: int = 5

#Calling all setup to get Game ready.
func _ready() -> void:
	
	_icon_grid_setup()
	
	desktop_folder = FileSys.desktop_folder
	
	link_to_parent(desktop_folder)
	
	_refresh_grid()
	
	#Control for right click signal
	RightClickMenu.request_refresh.connect(_on_menu_request)
	RightClickMenu.request_rename.connect(_on_menu_rename_request)
	RightClickMenu.request_virus_scan.connect(_on_virus_scan_request)
	RightClickMenu.request_contain.connect(_contian_virus)
	RightClickMenu.reverse_engineer.connect(_reverse_engineer_call)
	
	
	#Clock signal
	Clock.time_passed.connect(_clock_update)
	Clock.game_over_signal.connect(_handle_game_state)
	
	InfectionManager.trigger_popup.connect(_on_icon_open)
	InfectionManager.trigger_notification.connect(_spawn_notification)
	InfectionManager.containment_breached.connect(_on_containment_breach)
	
	
	#InfectionManager._inject_malware(AdwareVirus, "Adware", 1)
	
	_spawn_random_virus()
	
#handles all user input
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_selected = null
			
		_deselect_all_icon()
		
		if event.button_index == MOUSE_BUTTON_RIGHT:
			RightClickMenu._open_menu(desktop_folder, get_global_mouse_position(), null)
			

#stop selection UI
func _deselect_all_icon() -> void:
	for child in icon_grid.get_children():
		if child.has_method("deselect"):
			child.deselect()


#Changing grid seperation can be modified to adjustr automatically will be worked on later
func _icon_grid_setup() -> void:
	#Desktop_grid sepeartion
	
	icon_grid.columns = grid_column
	icon_grid.add_theme_constant_override("h_separation", 150)
	icon_grid.add_theme_constant_override("v_separation",100)
	
	#icon_grid seperation
	taskbar_grid.add_theme_constant_override("h_separation", 50)


#linking every folder to thier parent as a linked list
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
	
func create_base_window(title: String, icon_text: Texture2D) -> Node:
	var new_window = window_scene.instantiate()
	add_child(new_window)
	new_window.set_title(title)
	new_window.state.connect(_control_window_state) #connects with window to change open, close. minimize
	
	var taskbar_button = Button.new()
	if icon_text != null:
		taskbar_button.icon = icon_text
	else:
		taskbar_button.text = "Sys"
	taskbar_button.custom_minimum_size = Vector2(64,64) #size of icon in minimize mode
	taskbar_grid.add_child(taskbar_button)
	
	minimize_icon_to_window[new_window] = taskbar_button
	taskbar_button.pressed.connect(func(): _control_window_state(new_window, "opened"))
	
	return new_window
	
	
#Opening Window which later holds its contnet
func _on_icon_open(data: FileResource) -> void:
	
	var new_window = create_base_window(data.display_name, data.icon_texture)
	
	#calls another node for content gen
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
				
				
#UI
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
					
					
#file movement
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
	
func _spawn_random_virus() -> void:
	var virus_pool = [Rename_Virus, AdwareVirus, file_eater, destruction]
	
	var fake_names = ["1.exe", "2.exe", "3.exe", "4.exe"]
	var all_item = FileSys._get_all_files(FileSys.desktop_folder)
	
	var all_folders: Array[FileResource] = [FileSys.desktop_folder]
	
	for item in all_item:
		if item.file_type == FileResource.FileType.FOLDER:
			all_folders.append(item)
	
	for i in range(difficulty):
		var chosen_virus = virus_pool.pick_random()
		var chosen_name = fake_names.pick_random()
		var tick_rate = randf_range(4.0, 12.0)
		var chosen_folder = all_folders.pick_random()
		
		fake_names.erase(chosen_name)
		InfectionManager._inject_malware(chosen_virus, chosen_name, tick_rate, chosen_folder)
		
#Defender Tool
func _on_virus_scan_request(file: FileResource) -> void:	
	var scanner = Scanner_scence.instantiate()
	add_child(scanner)
	scanner.hide()
	scanner.finsih_scan.connect(_on_scan_finish)
	scanner.start_scan(file)
	
func _on_scan_finish(threats: Array[FileResource]) -> void:
	if threats.is_empty():
		_show_notification("Safe", "No threat Found")
		return
	var  names: PackedStringArray = []
	for t in threats:
		names.append(t.display_name)
		
	var title = "%d threat%s Detected" % [threats.size(), "" if threats.size() ==  1 else "s"]
	_show_notification(title, "Found: " + " ".join(names))
	
	
	
func _contian_virus(file: FileResource) -> void:
	var success = InfectionManager.attempt_containment(file, 2.0)
	if success:
		_show_notification("Threat Contianed", "%sContained for%d" % [file.display_name, int(2)])
	else:
		_show_notification("Containment Failed", "%s is not an acive threat" % file.display_name)
		
func _on_containment_breach(file:FileResource) -> void:
	print("containment breach")
	_show_notification("Containment_breach!", "%s is active again" % file.display_name)
	
	
func _reverse_engineer_call(file: FileResource) -> void:
	_on_icon_open(file)
	
#func Containement(file:FileResource) -> void:
	
	
#changing clock 
func _clock_update(hours: int, minute:int) -> void:
	var time_string = "%02d:%02d" % [hours, minute] 
	clock.text = time_string
	
func _spawn_notification(data: FileResource) -> void:
	_show_notification(data.display_name, data.text_content)


func _show_notification(title: String, body: String) -> void:
	var pop = notification_scence.instantiate()
	notification_area.add_child(pop)
	pop.setup(title, body, 8.0)


#may be moved
func _handle_game_state(game_state: bool) -> void:
	if game_state:
		print("Winner")
	else:
		print("Lost")
	pass
