class_name VelocityComponent
extends Node

@export var keep_distance := 0.0
@export var character_body: CharacterBody2D
@export var max_speed: float = 50
@export var acceleration: float = 15
var velocity: Vector2 = Vector2.ZERO


func accelerate_to_player():
	var player = Utils.get_player()
	if player == null:
		return
		
	var distance_to_player: float = character_body.global_position.distance_to(player.global_position)
	if distance_to_player <= keep_distance:
		return
	
	var direction: Vector2 = character_body.global_position.direction_to(player.global_position)
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1.0 - exp(-acceleration * get_physics_process_delta_time()))
	
	
func move():
	if character_body == null:
		return
		
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
