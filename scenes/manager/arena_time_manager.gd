extends Node

@export var arena_duration: float = 60

@onready var timer: Timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)
	timer.wait_time = arena_duration
	timer.start()


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	GameEvents.arena_timeout.emit()
