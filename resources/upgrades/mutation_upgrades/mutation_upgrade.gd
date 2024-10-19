class_name MutationUpgrade
extends Resource

enum Id {
	SPEED_UP,
}

@export var id: Id
@export var title: String
@export var max_quantity: int
@export_multiline var description: String
