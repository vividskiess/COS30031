extends Control

signal back_requested

@export_file("*.tscn") var game_scene: String
@export var account_card: PackedScene
@export var levels: Array[LevelData] = []


func _ready() -> void:
	for level in levels:
		var card := account_card.instantiate()
		%Accounts.add_child(card)
		card.setup(level)
		card.pressed.connect(_on_account_pressed)


func _on_account_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)


func _on_back_pressed() -> void:
	back_requested.emit()
