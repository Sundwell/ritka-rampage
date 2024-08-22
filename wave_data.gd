extends Resource

class_name WaveData

@export var start_time := 0
@export var end_time := 30
@export var enemy : PackedScene
@export var spawn_delay := 1.0
@export var level := 1

var time_from_last_spawn := 0.0

func can_spawn(current_time: int):
	return current_time >= start_time and current_time <= end_time and time_from_last_spawn >= spawn_delay
