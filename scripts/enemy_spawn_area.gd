extends Area2D

@export var area_collision : CollisionShape2D
@export var player_camera : Camera2D
@export var waves : Array[WaveData]

const MIN_SPAWN_DISTANCE_FROM_PLAYER := 50.0

var current_time := 0
var player
var area_rect : Rect2

func _ready():
	player = get_tree().get_first_node_in_group('player')
	area_rect = area_collision.shape.get_rect()

func _on_spawn_timer_timeout():
	for wave in waves:
		if wave.can_spawn(current_time):
			wave.time_from_last_spawn = 0.0
			var enemy = wave.enemy.instantiate()
			enemy.position = get_random_point()
			add_child(enemy)
		else:
			wave.time_from_last_spawn += $SpawnTimer.wait_time
	

# Get random point at least MIN_SPAWN_DISTANCE_FROM_PLAYER
func get_random_point():
	var x = randf_range(area_rect.position.x, area_rect.position.x + area_rect.size.x)
	var y = randf_range(area_rect.position.y, area_rect.position.y + area_rect.size.y)
	
	var random_point = global_position + Vector2(x, y)
	
	var player_position = player.global_position
	
	var x_distance = abs(random_point.x - player_position.x)
	var y_distance = abs(random_point.y - player_position.y)
	var is_point_near_player = (x_distance + y_distance) <= MIN_SPAWN_DISTANCE_FROM_PLAYER
	
	if is_point_near_player:
		return get_random_point()
		
	
	return random_point


func _on_time_passed_time_changed(seconds):
	current_time = seconds
