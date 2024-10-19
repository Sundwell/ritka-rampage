class_name PistolBullet
extends Node2D

const BASE_SPEED = 250.0
const BASE_MAX_DISTANCE = 130.0

var speed := BASE_SPEED
var max_distance := BASE_MAX_DISTANCE
var travelled_distance := 0

@export var hitbox_component: HitboxComponent


func _ready():
	$HealthComponent.died.connect(on_died)
	
	
func apply_upgrades(upgrades: Dictionary):
	var ballistics_count: int = Utils.get_upgrade_quantity(upgrades, PistolUpgrade.Id.IMPROVED_BALLISTICS)
	
	speed = BASE_SPEED + ((BASE_SPEED * 0.1) * ballistics_count)
	max_distance = BASE_MAX_DISTANCE + ((BASE_MAX_DISTANCE * 0.1) * ballistics_count)


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	
	if travelled_distance >= max_distance:
		queue_free()
		
		
func on_died():
	queue_free()
