extends Node2D

@onready var reload_timer = $ReloadTimer

@export var bullet_scene: PackedScene
var can_shoot := true
var base_reload_time: float


func _ready():
	base_reload_time = reload_timer.wait_time
	GameEvents.mutation_upgrade_selected.connect(on_mutation_upgrade_selected)


func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	var processed_rotation_degrees = abs(int(global_rotation_degrees) % 180)
	var should_flip = processed_rotation_degrees < 180 and processed_rotation_degrees > 90
	
	%WeaponSprite.flip_v = should_flip
	
	
func shoot():
	if not can_shoot:
		return

	can_shoot = false
	reload_timer.start()
	var bullet = bullet_scene.instantiate() as PistolBullet
	bullet.hitbox_component.damage = 2.0
	
	bullet.position = %ShootPosition.global_position
	
	if %WeaponSprite.flip_v:
		# Correction due to sprite flip_v
		bullet.position.y -= 4
	
	bullet.rotation = %ShootPosition.global_rotation
	
	get_parent().add_child(bullet)


func on_mutation_upgrade_selected(upgrade: MutationUpgrade, current_upgrades: Dictionary):
	if not upgrade.id == MutationUpgrade.Type.SHOOT_RATE:
		return
		
	var reduce_percent = current_upgrades[upgrade.id]["quantity"] * 0.1
	reload_timer.wait_time = max(base_reload_time * (1 - reduce_percent), 0.05)


func _on_reload_timeout():
	can_shoot = true
