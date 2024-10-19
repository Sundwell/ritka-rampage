extends Node2D

const BASE_RELOAD_TIME = 0.3

@export var bullet_scene: PackedScene

var can_shoot := true
var reload_time := BASE_RELOAD_TIME
var damage := 2.0
var bullet_count := 1
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
	
	for i in bullet_count:
		var bullet = bullet_scene.instantiate() as PistolBullet
		bullet.hitbox_component.damage = damage
		bullet.position = shoot_position.global_position
		
		var bullet_rotation_degrees: float = global_rotation_degrees
		
		if upgrades.has(PistolUpgrade.Id.MORE_BULLETS):
			bullet_rotation_degrees = bullet_rotation_degrees - randi_range(-30, 30)
		
		
		bullet.rotation = deg_to_rad(bullet_rotation_degrees)
		bullet.apply_upgrades(upgrades)
		
		entities.add_child(bullet)
	
	
func apply_upgrade(upgrade: WeaponUpgrade):
	match upgrade.get_id():
		PistolUpgrade.Id.SHOOT_RATE:
			reload_timer.wait_time = (BASE_RELOAD_TIME - ((BASE_RELOAD_TIME * 0.1) * upgrades[PistolUpgrade.Id.SHOOT_RATE].quantity))
		PistolUpgrade.Id.DAMAGE_UP:
			damage = 2.0 + upgrades[PistolUpgrade.Id.DAMAGE_UP].quantity
		PistolUpgrade.Id.MORE_BULLETS:
			bullet_count += 1


func on_reload_timer_timeout():
	can_shoot = true
	
	
func on_weapon_upgrade_selected(upgrade: WeaponUpgrade, current_upgrades: Dictionary):
	if upgrade is not PistolUpgrade:
		return
		
	upgrades = current_upgrades.duplicate()
	apply_upgrade(upgrade)
