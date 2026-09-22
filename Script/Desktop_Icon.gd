extends Button

signal icon_double_clicked(data: FileResource)

@onready var icon_texture_rect: TextureRect = $VBoxContainer/TextureRect
@onready var title_label: Label = $VBoxContainer/Label

var file_data:FileResource

func _on_mouse_entered() -> void: # need to add select and hovering animation soon
	pass
	
func _on_mouse_exit() -> void:
	pass
	
func _ready() -> void:
	pass

func setup(data: FileResource) -> void:
	file_data = data
	title_label.text = file_data.display_name
	icon_texture_rect.texture = file_data.icon_texture
	
func _gui_input(event: InputEvent) -> void: #fix to double click 
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			icon_double_clicked.emit(file_data)
