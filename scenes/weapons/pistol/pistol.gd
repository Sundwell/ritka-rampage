extends Node2D


@export var bullet_scene: PackedScene
var can_shoot := true
var base_reload_time: float
var damage := 2.0

@onready var shoot_position = $ShootPosition
@onready var reload_timer: Timer = $ReloadTimer
@onready var shoot_sound: AudioStreamPlayer = $SFX/Shoot


func _ready():
	base_reload_time = reload_timer.wait_time
	reload_timer.timeout.connect(on_reload_timer_timeout)
	
	GameEvents.mutation_upgrade_selected.connect(on_mutation_upgrade_selected)


func shoot():
	if not can_shoot:
		return

	can_shoot = false
	reload_timer.start()
	
	var bullet = bullet_scene.instantiate() as PistolBullet
	bullet.hitbox_component.damage = damage
	bullet.position = shoot_position.global_position
	bullet.rotation = global_rotation
	
	var entities = get_tree().get_first_node_in_group(Constants.GROUPS.ENTITIES_LAYER)
	entities.add_child(bullet)
	
	shoot_sound.play()


func on_reload_timer_timeout():
	can_shoot = true
	
	
func on_mutation_upgrade_selected(upgrade: MutationUpgrade, current_upgrades: Dictionary):
	match upgrade.id:
		MutationUpgrade.Type.SHOOT_RATE:
			var reduce_percent = current_upgrades[upgrade.id]["quantity"] * 0.1
			reload_timer.wait_time = max(base_reload_time * (1 - reduce_percent), 0.05)
		MutationUpgrade.Type.DAMAGE_UP:
			damage += 2.0
