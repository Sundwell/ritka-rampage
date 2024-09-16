extends Node

const MAX_SPAWN_RATE := 0.3

@export var difficulty_manager: DifficultyManager
@export var enemy_scene: PackedScene
var spawn_radius = int(ProjectSettings.get_setting('display/window/size/viewport_width') / 1.8)
var base_spawn_time: float

@onready var timer = $Timer


func _ready():
	timer.timeout.connect(_on_timer_timeout)
	base_spawn_time = timer.wait_time
	
	if not difficulty_manager == null:
		difficulty_manager.difficulty_level_update.connect(on_difficulty_level_update)
		

func get_spawn_position() -> Vector2:
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		return Vector2.ZERO
		
	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * spawn_radius)
		
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
	

func on_difficulty_level_update(new_difficulty: int):
	var new_spawn_time: float = max(MAX_SPAWN_RATE, base_spawn_time - (new_difficulty / 3.0))
	timer.wait_time = new_spawn_time
