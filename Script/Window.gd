extends PanelContainer


@onready var content_container = $VBoxContainer/MarginContainer
@onready var title_bar = $VBoxContainer/Title
@onready var mouse_node : TextureRect = get_tree().get_first_node_in_group("mouse") #if name were to change/ Change name "mouse" to the same as main scence
@onready var close_button = $VBoxContainer/Title/Close
@onready var minimize_button = $VBoxContainer/Title/Minimize
@onready var resize_button = $VBoxContainer/Title/Resize

signal state(window_node: Node, new_state:String)


#3 state Opened, Closed, Minimized
var curr_state = "open"

var is_dragging = false
var offset_drag: Vector2 = Vector2.ZERO

func _ready() -> void:
	title_bar.gui_input.connect(_on_title_bar_gui_input)
	close_button.pressed.connect(_on_close_button)
	minimize_button.pressed.connect(_on_minimize_button)
	
	#mouse handling for window
	if mouse_node:
		mouse_node.snapped_pos.connect(_mouse_pos_snapped)
	else:
		push_warning("Error Mouse Node")

func set_title(title_text: String) -> void:
	$VBoxContainer/Title/Label.text = title_text
	pass

func embed_content(node: Control) -> void:
	for child in content_container.get_children():
		child.queue_free()
	content_container.add_child(node)
	pass
	
func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():	
			print("Test1")
			is_dragging = true
			offset_drag = get_global_mouse_position() - global_position
			move_to_front()
		else:
			is_dragging = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.is_pressed():
		is_dragging = false
		
func _on_close_button()-> void:
	#print("Close") Testing purposes
	curr_state = "closed"
	state.emit(self, curr_state)
	
func _on_minimize_button()->void:
	curr_state="minimized"
	state.emit(self, curr_state)

			
func _mouse_pos_snapped(new_pos: Vector2) -> void:
	if is_dragging:
		#trying to prevent window from going off screen
		var target_pos = new_pos - offset_drag
		var viewport_size = get_viewport_rect().size
		
		target_pos.x = clamp(target_pos.x, 0, viewport_size.x - size.x)
		target_pos.y = clamp(target_pos.y, 0, viewport_size.y - size.y)
		
		#getting mouse position
		global_position = target_pos
