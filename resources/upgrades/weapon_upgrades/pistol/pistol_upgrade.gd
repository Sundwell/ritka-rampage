class_name PistolUpgrade
extends WeaponUpgrade

enum Id {
	# Stat
	SHOOT_RATE,
	DAMAGE_UP,
	IMPROVED_BALLISTICS,
	# Mechanic
	MORE_BULLETS
}

@export var id: Id
