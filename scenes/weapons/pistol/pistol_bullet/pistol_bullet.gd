class_name PistolBullet
extends Node2D

const BASE_SPEED = 250.0
const BASE_MAX_DISTANCE = 130.0
const MAX_RICOCHET_DISTANCE = 80.0
const TRAIL_COLOR_MAPPING = {
	"zenith": "#88d6ffb1",
	"shotgun": "#abaebeb1",
}

@export var base_max_health := 1.0
@export var hitbox_component: HitboxComponent
@export var base_damage = 2.0
@export var explosion_scene: PackedScene
@export var tick_status_scene: PackedScene
@export var shotgun_bullet_texture: Texture
@export var zenith_bullet_texture: Texture

var speed := BASE_SPEED
var max_distance := BASE_MAX_DISTANCE
var travelled_distance := 0
var upgrades_count := {}
var exploded_count := 0
var is_zenith := false
var is_shotgun := false

@onready var health_component: HealthComponent = $HealthComponent
@onready var projectile_hurtbox_component: Area2D = $ProjectileHurtboxComponent
@onready var bullet_sprite: Sprite2D = $BulletSprite
@onready var bullet_trail: Line2D = $BulletTrail


func _ready():
	_set_max_health(base_max_health)
	projectile_hurtbox_component.collided.connect(_on_collided)
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
	for id: PistolUpgrade.Id in PistolUpgrade.Id.values():
		upgrades_count[id] = Utils.get_upgrade_quantity(upgrades, id)
		
	is_zenith = upgrades_count[PistolUpgrade.Id.ZENITH] > 0
	is_shotgun = upgrades_count[PistolUpgrade.Id.SHOTGUN] > 0
	
		
func apply_upgrades(upgrades: Dictionary):
	_update_upgrades_count(upgrades)
	
	if is_zenith:
		bullet_sprite.texture = zenith_bullet_texture
		bullet_trail.gradient.colors[1] = Color(TRAIL_COLOR_MAPPING.zenith)
		
	if is_shotgun:
		bullet_sprite.texture = shotgun_bullet_texture
		bullet_trail.gradient.colors[1] = Color(TRAIL_COLOR_MAPPING.shotgun)
	
	var ballistics_count: int = upgrades_count[PistolUpgrade.Id.IMPROVED_BALLISTICS]
	speed = BASE_SPEED + ((BASE_SPEED * 0.1) * ballistics_count)
	max_distance = BASE_MAX_DISTANCE + ((BASE_MAX_DISTANCE * 0.1) * ballistics_count)
	
	var piercing_shots_count: int = upgrades_count[PistolUpgrade.Id.PIERCING_SHOTS]
	if piercing_shots_count > 0:
		if is_shotgun:
			speed *= 1.2
			max_distance *= 1.2
		_set_max_health(base_max_health + piercing_shots_count)
		speed *= 0.9 if is_zenith else 0.8
		
	var damage_up_count: int = upgrades_count[PistolUpgrade.Id.DAMAGE_UP]
	base_damage = base_damage + damage_up_count
	_set_damage(base_damage)
	
	var ricochet_count: int = upgrades_count[PistolUpgrade.Id.RICOCHET]
	if ricochet_count > 0:
		if is_shotgun:
			ricochet_count += 1
		
		var damage_multiplier: float = 0.85 if is_zenith else 0.7
		
		_set_max_health(base_max_health + ricochet_count)
		_set_damage(base_damage * damage_multiplier)
		
	var bloody_burden_count: int = upgrades_count[PistolUpgrade.Id.BLOODY_BURDEN]
	if bloody_burden_count > 0:
		var status: TickStatus = tick_status_scene.instantiate()
		var tick_time: float = 1.0 - (0.25 * (bloody_burden_count - 1))
		status.setup(hitbox_component.damage * 0.3, 3.0, tick_time)
		hitbox_component.statuses.append(status)
		
		
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
			func(enemy_near: Node2D):
				return enemy_near.global_position.distance_to(global_position) <= MAX_RICOCHET_DISTANCE
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
	var explosion = explosion_scene.instantiate() as Explosion
	explosion.set_damage(damage)
	explosion.global_position = global_position
	Utils.get_entities_layer().add_child(explosion)
	
	
func _can_create_explosion() -> bool:
	if is_zenith:
		return true
	
	return exploded_count == 0


func _on_collided(other: Node2D):
	if other.is_in_group(Constants.GROUPS.DECORATION):
		health_component.kill()
	else:
		health_component.damage(1)

	hitbox_component.clear_statuses.call_deferred()
	
	var explosive_impact_count: int = upgrades_count[PistolUpgrade.Id.EXPLOSIVE_IMPACT]
	if explosive_impact_count > 0 and _can_create_explosion():
		exploded_count += 1
		var explosion_damage = hitbox_component.damage * (explosive_impact_count * 0.15)
		Callable(_create_explosion.bind(explosion_damage)).call_deferred()
	
	if health_component.get_health_percent() == 0:
		return
	
	if upgrades_count[PistolUpgrade.Id.PIERCING_SHOTS] > 0:
		var new_damage: float = max(1, hitbox_component.damage - (base_damage * 0.3))
		Callable(_set_damage.bind(new_damage)).call_deferred()
		
	if upgrades_count[PistolUpgrade.Id.RICOCHET] > 0:
		ricochet()
