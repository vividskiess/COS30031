extends Node2D

# The level script will procedurally generate a maze for the level scene each time it is called.
# The maze is generated through the Recursive Backtrack algorithm.

# Starting cell is picked and marked visited.
# In the case any neighbouring cell has not been visited:
	# Picks a random neighboring cell that hasn't been visited.
	# Removes the wall between the two cells.
	# Adds the current cell to the stack.
	# Makes the chosen cell the current cell, and marks it as visited.
# If the current cell has no unvisited neighbors, take the top cell from the stack and amke it current.
# Repeat from #2 until there are no more unvisited cells.

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {
	Vector2(0, -1): N, 
	Vector2(1, 0): E,
	Vector2(0, 1): S,
	Vector2(-1, 0): W}

var tile_size = 16 # Tile size (pixels)
var width = 30 # Maze width (tiles)
var height = 17 # Maze width (tiles)

var maze_seed = 0 # Seed value for map.

@onready var Map = $TileMapLayer # Reference to the tile map for convenience.

func _ready():
	randomize()
	if !maze_seed:
		maze_seed = randi()
	seed(maze_seed)
	print("Seed: ", maze_seed)
	tile_size = Map.tile_set.tile_size
	make_maze()

func check_neighbours(cell, unvisited):
	# Returns array of the cell's unvisited neighbours.
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list

func make_maze():
	var unvisited = [] # Array of unvisited tiles.
	var stack = [] # Fills the map with solid tiles.
	Map.clear()
	for x in range (width):
		for y in range (height):
			unvisited.append(Vector2(x, y))
			Map.set_cell(Vector2(x, y), N|E|S|W, Vector2i(0, 0), 0)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	
	# Recursive backtrack algorithm.
	while unvisited:
		var neighbours = check_neighbours(current, unvisited)
		if neighbours.size() > 0:
			var next = neighbours[randi() % neighbours.size()]
			stack.append(current)
			# Remove walls from both cells.
			var dir = next - current
			var current_walls = Map.get_cell_source_id(current) - cell_walls[dir]
			var next_walls = Map.get_cell_source_id(next) - cell_walls[-dir]
			Map.set_cell(current, current_walls, Vector2i(0, 0), 0)
			Map.set_cell(next, next_walls, Vector2i(0, 0), 0)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
