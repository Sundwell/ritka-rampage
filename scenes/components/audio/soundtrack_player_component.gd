class_name SoundtrackPlayerComponent
extends AudioStreamPlayer

var initial_volume: float


func _ready() -> void:
	initial_volume = volume_db
	GameEvents.game_paused.connect(on_game_paused)
	
	
func on_game_paused(is_paused: bool):
	volume_db = initial_volume - 10.0 if is_paused else initial_volume
