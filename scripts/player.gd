extends CharacterBody2D

# Variables set when scene is ready.
@onready var screen_size = get_viewport_rect().size # Get screen size (480x270, 960x540) values.

# Adjustable variables in inspector w/ default values.
@export var move_speed: float = 100.0 # Movement speed.

# All other variables.
var has_key = false # Flag for level key.

# Function for initialising.
func _ready() -> void:
	position = Vector2(screen_size.x/2, screen_size.y) # Set starting position - might change per level.

# Function for movement.
func _physics_process(_delta: float) -> void:
	var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = move_direction * move_speed
	move_and_slide()
	
	# Ensuring player cannot move outside viewport - also adjusted for sprite pixels.
	position = position.clamp(Vector2(8, 8), screen_size - Vector2(8, 8))
