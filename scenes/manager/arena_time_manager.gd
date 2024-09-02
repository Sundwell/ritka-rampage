extends Node

@onready var timer: Timer = $Timer

@export var end_screen_scene: PackedScene


func _ready():
	timer.timeout.connect(on_timer_timeout)


func get_time_elapsed():
	return timer.wait_time - timer.time_left


func on_timer_timeout():
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
