extends Control

var _latest_mouse_pos

signal request_refresh()


@onready var menu = $PopupMenu

var rect_size_x = 500
var rect_size_y = 100

enum PopupIds{
	copy,
	paste,
	scanner, 
	container,
	
}

func _ready():
	menu.add_item("Copy", PopupIds.copy)
	menu.add_item("Paste", PopupIds.paste)
	menu.add_item("Scanner", PopupIds.scanner)
	menu.add_item("Container", PopupIds.container)
	

func _input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_latest_mouse_pos = get_global_mouse_position()
			menu.popup(Rect2(_latest_mouse_pos.x, _latest_mouse_pos.y, rect_size_x, rect_size_y))
			
func _on_item_pressed(id: int) -> void:
	match id:
		0:
			FileSys.copy_file()
		1:
			FileSys.paste_file()
			
