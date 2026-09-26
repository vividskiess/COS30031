extends Button

signal icon_double_clicked(data: FileResource)

signal icon_selected(data:FileResource)

@onready var icon_texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var title_label: Label = $VBoxContainer/Label
@onready var change_file_name: LineEdit = $VBoxContainer/LineEdit

#Selection section
var selected_file: FileResource = null
var file_data:FileResource
var is_selected = false

func _ready() -> void:
	#for mouse hovering affect
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exit)
	
	change_file_name.text_submitted.connect(_on_rename_submit)
	change_file_name.focus_exited.connect(func(): _on_rename_submit(change_file_name.text))
	
	
#Changing the colour to signifty hovering over it
func _on_mouse_entered() -> void: # need to add select and hovering animation soon
	if not is_selected:
		modulate = Color(1.2, 1.2, 1.2) #make it brighter
	
func _on_mouse_exit() -> void:
	if not is_selected:
		modulate = Color(1.0, 1.0, 1.0) #return it normal

#intialize all data and setup the actual icon
func setup(data: FileResource) -> void:
	file_data = data
	title_label.text = file_data.display_name
	icon_texture_rect.texture = file_data.icon_texture

#handles all input from mouse and keyboard maybe 
func _gui_input(event: InputEvent) -> void: #fix to double click 
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.double_click:
				icon_double_clicked.emit(file_data)
			else:
				_select_icon()
				
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if file_data:
				_select_icon()
				print(file_data.display_name)
				RightClickMenu._open_menu(file_data.parent_path, get_global_mouse_position(), file_data)

#Icon Selection Will be used for checking if file selected is actually malicous
func _select_icon() -> void:
	is_selected = true
	modulate = Color (0.7, 0.7, 1.5)
	icon_selected.emit(file_data)

func deselect() -> void:
	is_selected = false
	modulate = Color(1.0, 1.0, 1.0)
	
#Drag and drop function
func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.texture = file_data.icon_texture
	set_drag_preview(preview)
	return file_data
	
#Renaming Function	
func _start_renaming() -> void:
	title_label.hide()
	change_file_name.show()
	change_file_name.text = file_data.display_name
	change_file_name.grab_focus()
	change_file_name.select_all()
	
func _on_rename_submit(name:String) -> void:
	if name.strip_edges() != "": #Check if its null
		file_data.display_name = name
	title_label.text = file_data.display_name
	
	change_file_name.hide()
	title_label.show()
