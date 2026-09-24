extends TextureRect

signal snapped_pos(new_pos: Vector2)

func _ready() -> void:
	add_to_group("mouse")
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN 

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	snapped_pos.emit(global_position)	
	
	
