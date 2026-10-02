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

var counter = 0
var key_spawn = (width * height)/2 - 1
var exit_spawn = (width * height) - 1 

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
	for n in cell_walls.keys(): # Goes through each of the cell walls.
		if cell + n in unvisited: # If the resulting addition of the current cell coordinates and the cell wall is an unvisited one, add it to the new list.
			list.append(cell + n)
	return list

func make_maze():
	var unvisited = [] # Array of unvisited tiles.
	var stack = [] # Fills the map with solid tiles.
	Map.clear()
	for x in range (width):
		for y in range (height):
			unvisited.append(Vector2(x, y)) # Fills unvisited with tile.
			Map.set_cell(Vector2(x, y), N|E|S|W, Vector2i(0, 0), 0) # Sets tile on tilemap as solid, where source id = 15, which is the value obtained from using OR on all 4 constants.
	var current = Vector2(0, 0) # Where we actually start filling in the maze.
	unvisited.erase(current) # Erases the current tile from unvisited, as it will now be visited in the code below.
	
	# Recursive backtrack algorithm.
	while unvisited:
		var neighbours = check_neighbours(current, unvisited) # Retrives an array of the current cell's unvisited neighbours.
		if neighbours.size() > 0: # If the returned neighbour list size is greater than 4 - otherwise skip.
			var next = neighbours[randi() % neighbours.size()] # Provides random entry in neighbour that will be the new path walked.
			stack.append(current) # Puts current cell in stack.
			# Remove walls from both cells.
			var dir = next - current # Figure out actual next cell to enter.
			var current_walls = Map.get_cell_source_id(current) - cell_walls[dir] # Get tile that represents the new no. of walls (1-4) for current tile.
			var next_walls = Map.get_cell_source_id(next) - cell_walls[-dir] # Get tile that will represent the new no. of walls (1-4) for the next tile.
			Map.set_cell(current, current_walls, Vector2i(0, 0), 0) # Actually replaces tile.
			Map.set_cell(next, next_walls, Vector2i(0, 0), 0) # Actually replaces tile.
			current = next # Next tile is now the current tile.
			unvisited.erase(current) # Erases the current tile from unvisited, as it will now be visited through a new iteration of this while loop.
			counter += 1
			if (counter == key_spawn or counter == exit_spawn):
				pass
		elif stack: # Checks if stack is currently not empty - this is only if there are no neighbours to be scanned - this is where we backtrack recursively.
			current = stack.pop_back()
		# await get_tree().create_timer(0.005).timeout # Shows maze creation in real time.
