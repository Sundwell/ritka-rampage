class_name MutationUpgrade
extends Resource

enum Type {
	RUN_WHILE_SHOOTING,
	SHOOT_RATE,
	DAMAGE_UP,
}

@export var id: Type
@export var title: String
@export var max_quantity: int
@export_multiline var description: String
