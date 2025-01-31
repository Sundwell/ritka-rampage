extends Node2D

@export var rotation_pivot: Marker2D
var is_active := false


func _ready() -> void:
	if not rotation_pivot:
		return

	GameEvents.anvil_spawned.connect(_on_anvil_spawned)


func _toggle_active(_is_active: bool):
	is_active = _is_active

	visible = is_active


func _fetch_anvils():
	return get_tree().get_nodes_in_group(Constants.GROUPS.ANVIL)
	

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	var anvils = _fetch_anvils() as Array[Node2D]

	if anvils.is_empty():
		_toggle_active(false)
		return

	var nearest_anvil = Utils.get_nearest_node_in_group(Constants.GROUPS.ANVIL, global_position)

	var target_rotation = rotation_pivot.global_position.angle_to_point(nearest_anvil.global_position)

	rotation_pivot.global_rotation = lerp_angle(
		rotation_pivot.global_rotation,
		target_rotation,
		delta * 10
	)

func _on_anvil_spawned():
	_toggle_active(true)
