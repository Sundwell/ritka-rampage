extends HSlider

@export var audio_bus_name: String = 'SFX'
@export var sound_on_drag_end: bool = false

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	drag_ended.connect(on_drag_ended)
	audio_stream_player.bus = audio_bus_name
	
	
func on_drag_ended(new_value: bool):
	if sound_on_drag_end:
		audio_stream_player.pitch_scale = randf_range(0.9, 1.1)
		audio_stream_player.play()
