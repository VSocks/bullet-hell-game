extends Node

var audio_pool = []
var pool_size = 150
var playing_sounds = 0
var max_concurrent_sounds = 100  # Adjust this

func _ready():
	for i in range(pool_size):
		var player = AudioStreamPlayer.new()
		add_child(player)
		audio_pool.append(player)

func play_sound(stream: AudioStream, db: int):
	# Limit how many bullet sounds can play simultaneously
	if playing_sounds >= max_concurrent_sounds:
		return
	
	var player = get_available_player()
	if player:
		playing_sounds += 1
		player.volume_db = db
		player.stream = stream
		player.play()
		# Connect to know when it finishes
		if not player.finished.is_connected(_on_sound_finished):
			player.finished.connect(_on_sound_finished.bind())

func _on_sound_finished():
	playing_sounds = max(0, playing_sounds - 1)


func get_available_player():
	for player in audio_pool:
		if not player.playing:
			return player
	# If all players are busy, create one more (optional)
	var player = AudioStreamPlayer.new()
	add_child(player)
	audio_pool.append(player)
	return player
