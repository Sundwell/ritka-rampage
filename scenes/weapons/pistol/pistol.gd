extends Weapon

const BASE_RELOAD_TIME = 0.3

@export var bullet_scene: PackedScene

var can_shoot := true
var reload_time := BASE_RELOAD_TIME
var upgrades := {}

@onready var shoot_position = $ShootPosition
@onready var reload_timer: Timer = $ReloadTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shot_sound: AudioStreamPlayer = $SFX/ShotSound


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
	
	animation_player.stop()
	animation_player.play("shoot")
	shot_sound.pitch_scale = randf_range(1, 1.1)
	shot_sound.play()
	
	var entities = Utils.get_entities_layer()
	
	var bullet_count: int = 1
	var more_bullets_count: int = Utils.get_upgrade_quantity(upgrades, PistolUpgrade.Id.MORE_BULLETS)
	
	if more_bullets_count > 0:
		var chance_for_additional_bullet: float = more_bullets_count * 0.15
		var has_additional_bullet: bool = randf_range(0, 1) <= chance_for_additional_bullet
		if has_additional_bullet:
			bullet_count += 1
	
	for bullet_number in range(bullet_count):
		var bullet = bullet_scene.instantiate() as PistolBullet
		bullet.position = shoot_position.global_position
		
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
	
	
func apply_upgrade(upgrade: WeaponUpgrade):
	match upgrade.get_id():
		PistolUpgrade.Id.SHOOT_RATE:
			reload_timer.wait_time = (BASE_RELOAD_TIME - ((BASE_RELOAD_TIME * 0.1) * upgrades[PistolUpgrade.Id.SHOOT_RATE].quantity))


func on_reload_timer_timeout():
	can_shoot = true
	
	
func on_weapon_upgrade_selected(upgrade: WeaponUpgrade, current_upgrades: Dictionary):
	if upgrade is not PistolUpgrade:
		return
		
	upgrades = current_upgrades.duplicate(true)
	apply_upgrade(upgrade)
