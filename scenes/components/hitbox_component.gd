class_name HitboxComponent
extends Area2D

@onready var timer: Timer = $Timer

@export var reload_time: float = 0.0
var damage := 0.0


func _ready():
	timer.wait_time = reload_time


func is_reloaded():
	return timer.is_stopped()
	
	
func start_reloading():
	if reload_time == 0.0:
		return
	
	timer.start()
	
	
	
