class_name WeaponUpgrade
extends Resource

enum Type {
	
}

enum Weapon {
	PISTOL
}

enum Rarity {
	COMMON,
	RARE,
	EPIC
}

const WEIGHT_BY_RARITY = {
	Rarity.COMMON: 5,
	Rarity.RARE: 3,
	Rarity.EPIC: 1,
}

@export var type: Type
@export var weapon: Weapon
@export var max_quantity: int
@export var rarity: Rarity
@export_multiline var description: String

var weight:
	get():
		return WEIGHT_BY_RARITY[rarity]
