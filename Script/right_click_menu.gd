extends Control

var _latest_mouse_pos

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

func _input(event:InputEvent)->void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_latest_mouse_pos = get_global_mouse_position()
			menu.popup(Rect2(_latest_mouse_pos.x, _latest_mouse_pos.y, rect_size_x, rect_size_y))
