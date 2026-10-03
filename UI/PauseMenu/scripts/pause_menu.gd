extends CanvasLayer

@export_file("*.tscn") var main_menu_scene: String

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_open := false


func _unhandled_input(event: InputEvent) -> void:
	if not is_open and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		open()


func _input(event: InputEvent) -> void:
	if not is_open:
		return
	if animation_player.is_playing():
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		close()


func open() -> void:
	is_open = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	animation_player.play("open")


func close() -> void:
	is_open = false
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	animation_player.play("close")


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene)


func _on_quit_pressed() -> void:
	get_tree().quit()
