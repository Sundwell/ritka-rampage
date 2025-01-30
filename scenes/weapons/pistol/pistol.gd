extends Weapon

const BASE_RELOAD_TIME = 0.3

@export var bullet_scene: PackedScene
@export var shotgun_variant_scene: PackedScene
@export var zenith_variant_scene: PackedScene

var can_shoot := true
var reload_time := BASE_RELOAD_TIME
var upgrades := {}

var is_shotgun := false
var is_zenith := false

@onready var reload_timer: Timer = $ReloadTimer
@onready var weapon_variant: PistolWeaponVariant = $DefaultVariant


func _ready():
	reload_timer.wait_time = reload_time
	reload_timer.start()
	reload_timer.timeout.connect(on_reload_timer_timeout)
	
	GameEvents.weapon_upgrade_selected.connect(on_weapon_upgrade_selected)


func shoot():
	if not can_shoot:
		return

	can_shoot = false
	reload_timer.start()
	
	weapon_variant.animation_player.stop()
	weapon_variant.play_shoot_animation()
	weapon_variant.play_shoot_sound()
	
	var entities = Utils.get_entities_layer()
	
	var bullet_count := 1
	var more_bullets_count: int = Utils.get_upgrade_quantity(upgrades, PistolUpgrade.Id.MORE_BULLETS)
	
	if more_bullets_count > 0:
		var chance_for_additional_bullet: float = more_bullets_count * 0.15
		var has_additional_bullet: bool = randf_range(0, 1) <= chance_for_additional_bullet
		if has_additional_bullet:
			bullet_count += 1
			
	if is_shotgun:
		bullet_count *= randi_range(1, 3)
	
	for bullet_number in range(bullet_count):
		var bullet = bullet_scene.instantiate() as PistolBullet
		bullet.position = weapon_variant.get_shoot_position()
		
		var bullet_rotation_degrees: float = global_rotation_degrees
		
		if bullet_count > 1:
			var multiplier: float = ceil((bullet_number) / 2.0)
			var is_bullets_even := bullet_count % 2 == 0
			
			if bullet_count == 2:
				multiplier = 1
			elif is_bullets_even:
				bullet_rotation_degrees -= 2.5
			
			var is_bullet_even = bullet_number % 2 == 0
			var rotation_multiplier = -multiplier if is_bullet_even else multiplier
			bullet_rotation_degrees += 5 * rotation_multiplier
		
		bullet.rotation = deg_to_rad(bullet_rotation_degrees)
		
		entities.add_child(bullet)
		bullet.apply_upgrades(upgrades)
		
		
func _replace_variant(variant_scene: PackedScene):
	var variant = variant_scene.instantiate() as PistolWeaponVariant
	weapon_variant.queue_free()
	add_child(variant)
	weapon_variant = variant
	
	
func apply_upgrade(upgrade: WeaponUpgrade):
	match upgrade.get_id():
		PistolUpgrade.Id.SHOOT_RATE:
			reload_timer.wait_time = (BASE_RELOAD_TIME - ((BASE_RELOAD_TIME * 0.1) * upgrades[PistolUpgrade.Id.SHOOT_RATE].quantity))
		PistolUpgrade.Id.SHOTGUN:
			is_shotgun = true
			_replace_variant(shotgun_variant_scene)
		PistolUpgrade.Id.ZENITH:
			is_zenith = true
			_replace_variant(zenith_variant_scene)


func on_reload_timer_timeout():
	can_shoot = true
	
	
func on_weapon_upgrade_selected(upgrade: WeaponUpgrade, current_upgrades: Dictionary):
	if upgrade is not PistolUpgrade:
		return
		
	upgrades = current_upgrades.duplicate(true)
	apply_upgrade(upgrade)
