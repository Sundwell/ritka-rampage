class_name Status
extends Node

signal removed

@export var duration_timer: Timer
@export var duration: float


func _ready() -> void:
	if not duration_timer:
		push_error('Duration Timer must be specified')
		return
		
	_refresh_duration_timer()
	duration_timer.timeout.connect(_on_duration_timer_timeout)
	
	
func _refresh_duration_timer():
	duration_timer.wait_time = duration
	duration_timer.start()
	
	
func _on_duration_timer_timeout():
	removed.emit()
	queue_free()
