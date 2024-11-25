class_name PistolBullet
extends Node2D

const BASE_SPEED = 250.0
const BASE_MAX_DISTANCE = 130.0
const MAX_RICOCHET_DISTANCE = 80.0

@export var base_max_health := 1.0
@export var hitbox_component: HitboxComponent
@export var base_damage = 2.0
@export var explosion_scene: PackedScene
var speed := BASE_SPEED
var max_distance := BASE_MAX_DISTANCE
var travelled_distance := 0
var upgrades_count := {}
var exploded_count := 0

@onready var health_component: HealthComponent = $HealthComponent
@onready var projectile_hurtbox_component: Area2D = $ProjectileHurtboxComponent


func _ready():
	_set_max_health(base_max_health)
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
		PistolUpgrade.Id.RICOCHET,
		PistolUpgrade.Id.EXPLOSIVE_IMPACT
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
		_set_max_health(base_max_health + piercing_shots_count)
		speed = speed * 0.8
		
	var damage_up_count: int = upgrades_count[PistolUpgrade.Id.DAMAGE_UP]
	base_damage = base_damage + damage_up_count
	_set_damage(base_damage)
	
	var ricochet_count: int = upgrades_count[PistolUpgrade.Id.RICOCHET]
	if ricochet_count > 0:
		_set_max_health(base_max_health + ricochet_count)
		_set_damage(base_damage * 0.7)
		
		
func ricochet():
	var enemies = get_tree().get_nodes_in_group(Constants.GROUPS.ENEMY)
	enemies.sort_custom(
			func(a: Node2D, b: Node2D): 
				return a.global_position.distance_to(global_position) < b.global_position.distance_to(global_position)
	)
	
	if enemies.is_empty():
		travelled_distance = 0
		rotation_degrees = randf_range(rotation_degrees - 15, rotation_degrees + 15)
		return
		
	var available_enemies = enemies.slice(1).filter(
			func (enemy: Node2D):
				return enemy.global_position.distance_to(global_position) <= MAX_RICOCHET_DISTANCE
	)
	
	if available_enemies.is_empty():
		travelled_distance = 0
		rotation_degrees = randf_range(rotation_degrees - 15, rotation_degrees + 15)
		return
	
	var random_idx = randi_range(0, available_enemies.size() - 1)
	var enemy = available_enemies[random_idx] as Node2D
	
	travelled_distance = 0
	rotation = global_position.direction_to(enemy.global_position).angle()
		

func on_died():
	queue_free()
	
	
func _create_explosion(damage: float):
	exploded_count += 1
	
	var explosion = explosion_scene.instantiate() as Explosion
	explosion.set_damage(damage)
	explosion.global_position = global_position
	Utils.get_entities_layer().add_child(explosion)
	
	
func _can_create_explosion() -> bool:
	return exploded_count == 0


func on_collided():
	health_component.damage(1)
	
	var explosive_impact_count: int = upgrades_count[PistolUpgrade.Id.EXPLOSIVE_IMPACT]
	if explosive_impact_count > 0 and _can_create_explosion():
		var explosion_damage = hitbox_component.damage * (explosive_impact_count * 0.15)
		Callable(_create_explosion.bind(explosion_damage)).call_deferred()
	
	if health_component.get_health_percent() == 0:
		return
	
	if upgrades_count[PistolUpgrade.Id.PIERCING_SHOTS] > 0:
		var new_damage: float = max(1, hitbox_component.damage - (base_damage * 0.3))
		Callable(_set_damage.bind(new_damage)).call_deferred()
		
	if upgrades_count[PistolUpgrade.Id.RICOCHET] > 0:
		ricochet()
