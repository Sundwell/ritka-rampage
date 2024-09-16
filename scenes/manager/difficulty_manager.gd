class_name DifficultyManager
extends Node

signal difficulty_level_update(difficulty: int)

var difficulty_level: int = 0


func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	
	
func on_timer_timeout():
	difficulty_level += 1
	difficulty_level_update.emit(difficulty_level)
