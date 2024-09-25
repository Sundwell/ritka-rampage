extends Node

@export var difficulty_stages: Array[DifficultyStage] = []
@export var difficulty_manager: DifficultyManager
var spawn_radius = int(ProjectSettings.get_setting('display/window/size/viewport_width') / 1.8)
var current_stage_index := 0
var current_stage: DifficultyStage:
	get:
		return difficulty_stages[current_stage_index]

@onready var timer = $Timer


func _ready():
	update_difficulty_stage(0)
	timer.timeout.connect(on_timer_timeout)
	
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
	
	
func pick_enemy_to_spawn():
	var total_weight: int = current_stage.get_total_weight()
	var random_weight: int = randi_range(0, total_weight)
	
	var weight := 0
	
	for enemy_spawn_config in current_stage.enemy_spawn_configs:
		weight += enemy_spawn_config.weight
		
		if weight >= random_weight:
			return enemy_spawn_config


func update_difficulty_stage(current_difficulty: int):
	var next_stage_index := current_stage_index + 1
	if difficulty_stages.size() < (next_stage_index + 1):
		return
		
	var next_stage: DifficultyStage = difficulty_stages[next_stage_index]

	if current_difficulty < next_stage.difficulty_level:
		return
	
	current_stage_index = current_stage_index + 1
	timer.wait_time = current_stage.time_to_spawn


func on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		return
		
	var enemy_spawn_config: EnemySpawnConfig = pick_enemy_to_spawn()
	
	var enemy = enemy_spawn_config.enemy_scene.instantiate()
	enemy.global_position = get_spawn_position()
	
	var entities_layer = get_tree().get_first_node_in_group('entities_layer')
	entities_layer.add_child(enemy)
	

func on_difficulty_level_update(new_difficulty: int):
	update_difficulty_stage(new_difficulty)
