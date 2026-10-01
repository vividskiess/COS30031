extends Control

const MAIN_WORLD := "res://Objects/Main_World.tscn"

@onready var lock_view: Control = $LockView
@onready var login_view: Control = $LoginView
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _input(event: InputEvent) -> void:
	if animation_player.is_playing():
		get_viewport().set_input_as_handled()
	elif lock_view.visible and _is_press(event):
		get_viewport().set_input_as_handled()
		animation_player.play("unlock")
	elif login_view.visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		animation_player.play("lock")


func _on_login_view_signed_in() -> void:
	get_tree().change_scene_to_file(MAIN_WORLD)


func _is_press(event: InputEvent) -> bool:
	return (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed() and not event.is_echo()
