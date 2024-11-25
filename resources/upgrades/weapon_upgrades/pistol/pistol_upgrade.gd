class_name PistolUpgrade
extends WeaponUpgrade

enum Id {
	# Stat
	SHOOT_RATE,
	DAMAGE_UP,
	IMPROVED_BALLISTICS,
	# Mechanic
	MORE_BULLETS,
	PIERCING_SHOTS,
	RICOCHET,
	EXPLOSIVE_IMPACT,
}

@export var id: Id
@export var incompatible_uprades: Array[Id]


func get_id() -> int:
	return id
	
	
func get_incompatible_upgrade_ids() -> Array[int]:
	return incompatible_uprades as Array[int]
