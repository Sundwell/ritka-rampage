extends Node

var SPAWN_RADIUS = int(ProjectSettings.get_setting('display/window/size/viewport_width') / 1.8)

@export var enemy_scene: PackedScene

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)


func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		return Vector2.ZERO
		
	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS)
		
		var query_params := PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		return
		
	var enemy = enemy_scene.instantiate() as Node2D
	
	enemy.global_position = get_spawn_position()
	
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	entities_layer.add_child(enemy)
