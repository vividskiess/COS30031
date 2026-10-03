extends Control

const MAIN_WORLD := "res://Objects/Main_World.tscn"
const LOCK_SCREEN := "res://UI/LockScreen/Lock_Screen.tscn"


func _on_primary_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_WORLD)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(LOCK_SCREEN)
