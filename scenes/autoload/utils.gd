extends Node


func get_player() -> Node2D:
	return get_tree().get_first_node_in_group(Constants.GROUPS.PLAYER)


func get_entities_layer() -> Node2D:
	return get_tree().get_first_node_in_group(Constants.GROUPS.ENTITIES_LAYER)
	

func get_foreground_layer() -> Node2D:
	return get_tree().get_first_node_in_group(Constants.GROUPS.FOREGROUND_LAYER)


func get_upgrade_quantity(upgrades: Dictionary, upgrade_key: Variant, default := 0) -> int:
	return upgrades.get(upgrade_key, {}).get("quantity", default)


func get_nearest_node_in_group(group: String, position: Vector2, excluded_nodes: Array = []) -> Node2D:
	var available_nodes = get_tree().get_nodes_in_group(group).filter(
			func(node: Node2D):
				return not excluded_nodes.has(node)
	)
	
	if available_nodes.is_empty():
		return null
	
	available_nodes.sort_custom(
			func(a: Node2D, b: Node2D):
				return a.global_position.distance_to(position) < b.global_position.distance_to(position)
	)
	
	return available_nodes[0]
	
	
func get_children_of_type(parent: Node, type) -> Array[Node]:
	return parent.get_children().filter(func(child): return is_instance_of(child, type))
