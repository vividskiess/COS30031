extends Node

# Number of audio players in the pool to handle overlapping sounds
const POOL_SIZE = 8
var _players: Array[AudioStreamPlayer] = []
var _current_player_index: int = 0

func _ready() -> void:
	# Initialize the audio player pool
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		add_child(player)
		_players.append(player)

## Play a sound effect from anywhere by calling SoundManager.play("res://path_to_sound.wav")
func play(stream_path: String, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	var stream = load(stream_path)
	if not stream:
		printerr("SoundManager: Failed to load stream at: ", stream_path)
		
	var player = _players[_current_player_index] as AudioStreamPlayer
	
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch_scale
	player.play()
	
	# Advance index and loop back if necessary
	_current_player_index = (_current_player_index + 1) % POOL_SIZE
