class_name HitboxComponent
extends Area2D

@export var reload_time: float = 0.5
@export var damage := 0.0

@onready var timer: Timer = $Timer


func _ready():
	if reload_time > 0:
		timer.wait_time = reload_time


func is_reloaded():
	return timer.is_stopped()
	
	
func start_reloading():
	if reload_time == 0.0:
		return
	
	timer.start()
