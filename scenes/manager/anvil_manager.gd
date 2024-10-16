class_name AnvilManager
extends Node

@export var first_spawn_time := 60.0
@export var spawn_time := 120.0
@export var anvil_scene: PackedScene

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = first_spawn_time
	timer.timeout.connect(on_timer_timeout)
	timer.start()
	
	
func get_spawn_position() -> Vector2:
	var player = Utils.get_player()
	
	if player == null:
		return Vector2.ZERO
		
	var spawn_position := Vector2.ZERO
	var random_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	var halved_player_view_radius: float = Constants.PLAYER_VIEW_RADIUS / 2
	
	for i in 4:
		spawn_position = player.global_position + (random_direction * halved_player_view_radius)
		
		var query_params := PhysicsRayQueryParameters2D.create(player.global_position, spawn_position, 1)
		var result: Dictionary = get_tree().root.world_2d.direct_space_state.intersect_ray(query_params)
		
		if result.is_empty():
			break
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
	
	return spawn_position
	
	
func spawn_anvil():
	var anvil := anvil_scene.instantiate() as Node2D
	anvil.global_position = get_spawn_position()
	
	Utils.get_entities_layer().add_child(anvil)


func on_timer_timeout():
	spawn_anvil()
	timer.wait_time = spawn_time
	timer.start()
	
