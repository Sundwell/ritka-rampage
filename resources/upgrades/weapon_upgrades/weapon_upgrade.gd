class_name WeaponUpgrade
extends Resource

enum Type {
	STAT,
	MECHANIC,
	EVOLUTION
}

const WEIGHT_BY_TYPE = {
	Type.STAT: 5,
	Type.MECHANIC: 3,
	Type.EVOLUTION: 1,
}

@export var title: String
@export var weapon: Constants.Weapon
@export var max_quantity: int
@export var type: Type
@export_multiline var description: String

var weight:
	get():
		return WEIGHT_BY_TYPE[type]
