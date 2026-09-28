extends Node2D

@onready var Map = $TileMapLayer # Reference to tile map for convenience.

const width = 30 # Maze width in tiles.
const height = 17 # Maze height in tiles.
const path = Vector2i(0, 0) # Atlas coordinates for navigatable path.
const wall = Vector2i(1, 0) # Atlas coordinates for wall.

var maze = []

func _ready() -> void:
	clear_maze()
	create_maze()

func clear_maze():
	pass

func create_maze():
	pass
