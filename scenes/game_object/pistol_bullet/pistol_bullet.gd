class_name PistolBullet
extends Node2D

var speed = 250
var max_distance = 130
var travelled_distance := 0

@export var hitbox_component: HitboxComponent


func _ready():
	$HealthComponent.died.connect(on_died)


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	
	if travelled_distance >= max_distance:
		queue_free()
		
		
func on_died():
	queue_free()
