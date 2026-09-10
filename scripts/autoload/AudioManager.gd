extends Node

var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []

var music_volume: float = 1.0
var sfx_volume: float = 1.0
var master_volume: float = 1.0

const MAX_SFX_PLAYERS = 8
const SOUNDS = {
	#TODO: Add preload statements with audio file paths
	SFX_VINEBOOM = "res://assets/sounds/vine_boom.mp3",
}

func _ready() -> void:
	_setup_music_player()
	_setup_sfx_players()

func _setup_music_player() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)

func _setup_sfx_players() -> void:
	for i in MAX_SFX_PLAYERS:
		var player = AudioStreamPlayer.new()
		player.bus = "SFX"
		add_child(player)
		sfx_players.append(player)

func set_device(device):
	self.output_device = device

func play_music(sound_name: String, fade_in: float = 0.0) -> void:
	if not SOUNDS.has(sound_name):
		push_warning("AudioManager: Sound not found: " + sound_name)
		return

	if music_player.stream == SOUNDS[sound_name] and music_player.playing:
		return

	music_player.stream = SOUNDS[sound_name]
	music_player.play()

	if fade_in > 0.0:
		music_player.volume_db = -80.0
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", linear_to_db(music_volume), fade_in)

func stop_music(fade_out: float = 0.0) -> void:
	if fade_out > 0.0:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80.0, fade_out)
		tween.tween_callback(music_player.stop)
	else:
		music_player.stop()

func play_sfx(sound_name: String, pitch_variation: float = 0.0) -> void:
	if not SOUNDS.has(sound_name):
		push_warning("AudioManager: Sound not found: " + sound_name)
		return

	var player = _get_free_sfx_player()
	if not player:
		return  # All players busy — drop the sound

	player.stream = SOUNDS[sound_name]
	player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
	player.play()

func _get_free_sfx_player() -> AudioStreamPlayer:
	for player in sfx_players:
		if not player.playing:
			return player
	return null  # No free player found

#Setter functions
func set_master_volume(value: float) -> void:
	master_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_volume))

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))

func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))

#Get and Set output device
func get_output_devices() -> PackedStringArray:
	return AudioServer.get_output_device_list()

func get_current_output_device() -> String:
	return AudioServer.output_device

func set_output_device(device_name: String) -> void:
	if device_name in AudioServer.get_output_device_list():
		AudioServer.output_device = device_name
	else:
		push_warning("AudioManager: Output device not found: " + device_name)
