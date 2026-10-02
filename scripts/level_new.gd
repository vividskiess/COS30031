extends Node2D

@onready var Map = $TileMapLayer # Reference to tile map for convenience.

const ROWS = 34 # Number of tile rows in the maze - height equivalent.
const COLUMNS = 60 # Number of tile columns in the maze - width equivalent.
const PATH = Vector2i(0, 0) # Atlas coordinates for navigatable path.
const WALL = Vector2i(1, 0) # Atlas coordinates for wall.

var maze = []

func _ready() -> void:
	create_maze()

func create_maze():
	clear_maze() # Resets the maze before creating one - a sanity check.
	
	var starting_row = 1
	var starting_column = 1
	maze[starting_row][starting_column] = 0
	
	make_path(starting_row, starting_column)
	
	draw_maze()

func clear_maze():
	maze = []
	for r in range(ROWS):
		var row = []
		for c in range(COLUMNS):
			row.append(1)
		maze.append(row)
		
func make_path(row, column):
	var directions = [
		[-2, 0], # North
		[0, 2], # East
		[2, 0], # South
		[0, -2] # West
	]
	
	directions.shuffle()
	
	for d in directions:
		var d_row = d[0]
		var d_column = d[1]
		
		var new_row = row + d_row
		var new_column = column + d_column
		
		if (new_row > 0 and 
		new_row < (ROWS - 1) and 
		new_column > 0 and 
		new_column < (COLUMNS - 1) and 
		maze[new_row][new_column] == 1):
			maze[new_row][new_column] = 0
			maze[row + d_row / 2][column + d_column / 2] = 0
			make_path(new_row, new_column)

func draw_maze():
	Map.clear()
	
	for r in range(ROWS):
		for c in range(COLUMNS):
			var tile_type = WALL if maze[r][c] == 1 else PATH
			Map.set_cell(Vector2i(c, r), 0, tile_type)
