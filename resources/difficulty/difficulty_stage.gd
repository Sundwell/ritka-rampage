class_name DifficultyStage
extends Resource

@export var enemy_spawn_configs: Array[EnemySpawnConfig]
@export var difficulty_level: int
@export var time_to_spawn := 1.0


func get_total_weight() -> int:
	return enemy_spawn_configs.reduce(
		func (accum: int, config: EnemySpawnConfig):
			return accum + config.weight,
		0
	)
