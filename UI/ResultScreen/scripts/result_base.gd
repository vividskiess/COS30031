extends Control

@export_file("*.tscn") var game_scene: String
@export_file("*.tscn") var main_menu_scene: String


func _on_primary_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
