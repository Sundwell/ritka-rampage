extends Node2D

var quill_speed: float = 120.0
var max_distance: float = 140.0
var travelled_distance: float = 0.0

@onready var projectile_hurtbox_component: ProjectileHurtboxComponent = $ProjectileHurtboxComponent


func _ready():
	$HealthComponent.died.connect(on_died)
	projectile_hurtbox_component.collided.connect(on_collided)


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	var speed_multiplier = max(0.5, 1.0 - (travelled_distance / max_distance))
	
	position += direction * delta * quill_speed * speed_multiplier
	
	travelled_distance += delta * quill_speed * speed_multiplier
	
	if travelled_distance >= max_distance:
		die()
		
		
func die():
	queue_free()
		
		
func on_died():
	die()
	
	
func on_collided():
	die()
