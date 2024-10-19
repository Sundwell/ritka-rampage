class_name MutationUpgrade
extends Resource

enum Type {
	FASTER_MOVEMENT,
	HEALTH_REGENERATION,
}

@export var id: Type
@export var title: String
@export var max_quantity: int
@export_multiline var description: String
