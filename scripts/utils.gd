extends Node


func get_player() -> Node2D:
	return get_tree().get_first_node_in_group(Constants.GROUPS.PLAYER)


func get_entities_layer() -> Node2D:
	return get_tree().get_first_node_in_group(Constants.GROUPS.ENTITIES_LAYER)
	

func get_foreground_layer() -> Node2D:
	return get_tree().get_first_node_in_group(Constants.GROUPS.FOREGROUND_LAYER)
