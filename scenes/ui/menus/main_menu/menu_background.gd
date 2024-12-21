@tool
extends TextureRect

@export var sprite_frames: SpriteFrames
var frames_count: int
var current_frame := 0

@onready var timer: Timer = $Timer


func _ready() -> void:
	frames_count = sprite_frames.get_frame_count('default')
	timer.timeout.connect(_on_timer_timeout)
	_process_animation()
	
	
func _process_animation():
	var frame_info = _get_frame_info()
	texture = frame_info['texture']
	current_frame = (current_frame + 1) % frames_count
	
	timer.wait_time = frame_info['duration']
	timer.start()
	
	
func _get_frame_info() -> Dictionary:
	var animation_fps: float = sprite_frames.get_animation_speed('default')
	return {
		'texture': sprite_frames.get_frame_texture('default', current_frame),
		'duration': sprite_frames.get_frame_duration('default', current_frame) / animation_fps,
	}
	

func _on_timer_timeout():
	_process_animation()
