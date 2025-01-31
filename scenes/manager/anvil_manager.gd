class_name AnvilManager
extends Node

signal time_to_spawn_changed(time_to_spawn: float)

@export var first_spawn_time := 30.0
@export var spawn_time := 75.0
@export var anvil_scene: PackedScene
var current_time_to_spawn: float

@onready var timer: Timer = $Timer


func _ready() -> void:
	current_time_to_spawn = first_spawn_time
	time_to_spawn_changed.emit(current_time_to_spawn)
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
	current_time_to_spawn = max(current_time_to_spawn - 1, 0)
	
	if current_time_to_spawn == 0:
		current_time_to_spawn = spawn_time
		spawn_anvil()

	time_to_spawn_changed.emit(current_time_to_spawn)

	timer.start()
