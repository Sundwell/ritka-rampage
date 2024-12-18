extends Node

@export var difficulty_stages: Array[DifficultyStage] = []
@export var difficulty_manager: DifficultyManager

var current_stage_index := 0
var current_stage: DifficultyStage:
	get:
		return difficulty_stages[current_stage_index]
var current_enemies_table: WeightedTable = WeightedTable.new()

@onready var timer = $Timer


func _ready():
	difficulty_stages.sort_custom(
			func (stageA: DifficultyStage, stageB: DifficultyStage):
				if stageA.difficulty_level < stageB.difficulty_level:
					return true
				return false
	)
	update_difficulty_stage(0)
	update_difficulty_stage_settings()
	timer.start()
	timer.timeout.connect(on_timer_timeout)
	
	if not difficulty_manager == null:
		difficulty_manager.difficulty_level_update.connect(on_difficulty_level_update)
		

func get_spawn_position() -> Vector2:
	var player = Utils.get_player()
	
	if player == null:
		return Vector2.ZERO
		
	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * Constants.PLAYER_VIEW_RADIUS)
		
		var query_params := PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position
	
	
func update_enemies_table():
	current_enemies_table.clear()
	
	for enemy_spawn_config in current_stage.enemy_spawn_configs:
		current_enemies_table.add_item(enemy_spawn_config, enemy_spawn_config.weight) 


func update_difficulty_stage_settings():
	timer.wait_time = current_stage.time_to_spawn
	update_enemies_table()


func update_difficulty_stage(current_difficulty: int):
	var next_stage_index := current_stage_index + 1
	if difficulty_stages.size() < (next_stage_index + 1):
		return
		
	var next_stage: DifficultyStage = difficulty_stages[next_stage_index]

	if current_difficulty < next_stage.difficulty_level:
		return
	
	current_stage_index = current_stage_index + 1
	update_difficulty_stage_settings()


func on_timer_timeout():
	var player = Utils.get_player()
	
	if player == null:
		return
		
	var enemy_spawn_config: EnemySpawnConfig = current_enemies_table.pick_random_item()
	
	var enemy = enemy_spawn_config.enemy_scene.instantiate()
	enemy.global_position = get_spawn_position()
	
	var entities_layer = get_tree().get_first_node_in_group(Constants.GROUPS.ENTITIES_LAYER)
	entities_layer.add_child(enemy)
	

func on_difficulty_level_update(new_difficulty: int):
	update_difficulty_stage(new_difficulty)
