class_name PistolBullet
extends Node2D

const BASE_SPEED = 250.0
const BASE_MAX_DISTANCE = 130.0

@export var base_health := 1.0
@export var hitbox_component: HitboxComponent
@export var base_damage = 2.0
var speed := BASE_SPEED
var max_distance := BASE_MAX_DISTANCE
var travelled_distance := 0
var upgrades_count := {}

@onready var health_component: HealthComponent = $HealthComponent
@onready var projectile_hurtbox_component: Area2D = $ProjectileHurtboxComponent


func _ready():
	_set_max_health(base_health)
	projectile_hurtbox_component.collided.connect(on_collided)
	health_component.died.connect(on_died)


func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * speed * delta
	
	travelled_distance += speed * delta
	
	if travelled_distance >= max_distance:
		queue_free()
		
		
func _set_max_health(health: float):
	health_component.set_max_health(health)
	
	
func _set_damage(damage: float):
	hitbox_component.damage = damage
		
		
func _update_upgrades_count(upgrades: Dictionary):
	const BULLET_UPGRADE_IDS = [
		PistolUpgrade.Id.IMPROVED_BALLISTICS,
		PistolUpgrade.Id.PIERCING_SHOTS,
		PistolUpgrade.Id.DAMAGE_UP,
	]
	
	for id: PistolUpgrade.Id in BULLET_UPGRADE_IDS:
		upgrades_count[id] = Utils.get_upgrade_quantity(upgrades, id)
		
		
func apply_upgrades(upgrades: Dictionary):
	_update_upgrades_count(upgrades)
	
	var ballistics_count: int = upgrades_count[PistolUpgrade.Id.IMPROVED_BALLISTICS]
	speed = BASE_SPEED + ((BASE_SPEED * 0.1) * ballistics_count)
	max_distance = BASE_MAX_DISTANCE + ((BASE_MAX_DISTANCE * 0.1) * ballistics_count)
	
	var piercing_shots_count: int = upgrades_count[PistolUpgrade.Id.PIERCING_SHOTS]
	if piercing_shots_count > 0:
		_set_max_health(base_health + piercing_shots_count)
		speed = speed * 0.8
		
	var damage_up_count: int = upgrades_count[PistolUpgrade.Id.DAMAGE_UP]
	base_damage = base_damage + damage_up_count
	_set_damage(base_damage)


func on_died():
	queue_free()


func on_collided():
	health_component.damage(1)
	
	var new_damage: float = max(1, hitbox_component.damage - (base_damage * 0.3))
	Callable(_set_damage.bind(new_damage)).call_deferred()
