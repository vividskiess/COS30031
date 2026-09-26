extends Button

signal icon_double_clicked(data: FileResource)

signal icon_selected(data:FileResource)

@onready var icon_texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var title_label: Label = $VBoxContainer/Label

var selected_file: FileResource = null

func _ready() -> void:
	#needs to check notepad
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exit)

var file_data:FileResource
var is_selected = false

func _on_mouse_entered() -> void: # need to add select and hovering animation soon
	if not is_selected:
		modulate = Color(1.2, 1.2, 1.2) #make it brighter
	
func _on_mouse_exit() -> void:
	if not is_selected:
		modulate = Color(1.0, 1.0, 1.0) #retunr it normal

func setup(data: FileResource) -> void:
	file_data = data
	title_label.text = file_data.display_name
	icon_texture_rect.texture = file_data.icon_texture
	
func _gui_input(event: InputEvent) -> void: #fix to double click 
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.double_click:
				icon_double_clicked.emit(file_data)
			else:
				_select_icon()

func _select_icon() -> void:
	is_selected = true
	modulate = Color (0.7, 0.7, 1.5)
	icon_selected.emit(file_data)

func deselect() -> void:
	is_selected = false
	modulate = Color(1.0, 1.0, 1.0)
	
func _get_drag_data(at_position: Vector2) -> Variant:
	var preview = TextureRect.new()
	preview.texture = file_data.icon_texture
	set_drag_preview(preview)
	
	return file_data
