extends Area2D

@export var area_collision : CollisionShape2D
@export var player_camera : Camera2D

var player

const MIN_SPAWN_DISTANCE_FROM_PLAYER := 50.0

var area_rect : Rect2
var enemy_scene = preload("res://scenes/bunny.tscn")

func _ready():
	player = get_tree().get_first_node_in_group('Player')
	area_rect = area_collision.shape.get_rect()

func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	
	enemy.position = get_random_point()
	
	add_child(enemy)
	

# Get random point at least 50px 
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
