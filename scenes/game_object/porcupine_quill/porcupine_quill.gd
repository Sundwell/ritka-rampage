extends Node2D

const DAMAGE: float = 8.0

var quill_speed: float = 120.0
var max_distance: float = 140.0
var travelled_distance: float = 0.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready():
	hitbox_component.damage = DAMAGE


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	var speed_multiplier = max(0.5, 1.0 - (travelled_distance / max_distance))
	
	position += direction * delta * quill_speed * speed_multiplier
	
	travelled_distance += delta * quill_speed * speed_multiplier
	
	if travelled_distance >= max_distance:
		queue_free()
