extends CharacterBody2D

const ATTACK_RANGE := 120.0
const ATTACK_CONE_DEGREES := 30
const WANDER_DISTANCE := 100.0
const RUN_FROM_PLAYER_DISTANCE := 50.0
const MOVE_SPEED := 60.0
const RUN_SPEED := 90.0

@export var quill_scene: PackedScene
var can_attack := true
var is_player_in_attack_range := false
var is_near_player := false
var should_run_from_player := false
var can_change_direction := true
var state_machine := CallableStateMachine.new()
var move_direction := Vector2.ZERO

@onready var actions_animation_player = $ActionsAnimationPlayer
@onready var reload_timer = $ReloadTimer
@onready var wander_direction_timer = $WanderDirectionTimer
@onready var visuals = $Visuals
@onready var run_particles: CPUParticles2D = %RunParticles
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _ready():
	reload_timer.timeout.connect(on_realod_timer_timeout)
	wander_direction_timer.timeout.connect(on_wander_direction_timer_timeout)
	
	state_machine.add_states(state_move)
	state_machine.add_states(state_attack, enter_state_attack)
	state_machine.add_states(state_die, enter_state_die)
	state_machine.set_initial_state(state_move)
	
	$HealthComponent.died.connect(on_died)


func _physics_process(delta: float):
	state_machine.update()


func start_moving():
	state_machine.change_state(state_move)
	
	
func state_move():
	update_player_proximity()
	
	if is_near_player and can_attack:
		state_machine.change_state(state_attack)
	else:
		move()
		
		
func exit_state_move():
	velocity = Vector2.ZERO


func enter_state_attack():
	velocity = Vector2.ZERO
	actions_animation_player.play('attack')


func state_attack():
	pass


func enter_state_die():
	velocity = Vector2.ZERO
	$HurtboxComponent.queue_free()
	$CollisionShape2D.queue_free()
	actions_animation_player.play('die')


func state_die():
	pass


func shoot():
	var player = Utils.get_player()
	
	if player == null:
		return
		
	var quill_count = randi_range(1, 3)
	var direction_to_player: Vector2 = global_position.direction_to(player.global_position)
	
	for index in quill_count:
		var quill = quill_scene.instantiate() as Node2D
		
		var random_angle = deg_to_rad(randf_range(ATTACK_CONE_DEGREES, -ATTACK_CONE_DEGREES))
		var random_direction = direction_to_player.rotated(random_angle)
		
		quill.rotation = random_direction.angle()
		quill.global_position = global_position
		get_parent().add_child(quill)
	
	can_attack = false
	reload_timer.start()
	
	
func update_player_proximity():
	var player = Utils.get_player()
	
	if player == null:
		return

	var distance_to_player: float = global_position.distance_squared_to(player.global_position)
	
	is_near_player = distance_to_player <= pow(WANDER_DISTANCE, 2)
	is_player_in_attack_range = distance_to_player <= pow(ATTACK_RANGE, 2)
	should_run_from_player = distance_to_player <= pow(RUN_FROM_PLAYER_DISTANCE, 2)


func change_direction(new_direction: Vector2):
	move_direction = new_direction
	can_change_direction = false
	wander_direction_timer.start()


func move():
	actions_animation_player.play('move')
		
	if not is_near_player and can_change_direction:
		velocity_component.max_speed = MOVE_SPEED
		velocity_component.accelerate_to_player()
	else:
		if should_run_from_player:
			var player = Utils.get_player()
			velocity_component.max_speed = RUN_SPEED
			if can_change_direction:
				change_direction(-global_position.direction_to(player.global_position))
		else:
			velocity_component.max_speed = MOVE_SPEED
			if can_change_direction:
				change_direction(Vector2.RIGHT.rotated(randf_range(0, TAU)))
		
		velocity_component.accelerate_in_direction(move_direction)
		
	velocity_component.move()
		
	flip_sprite_based_on_velocity()
	
	if should_run_from_player:
		run_particles.emitting = true
	else:
		run_particles.emitting = false
	
	
func flip(is_facing_left: bool):
	visuals.scale.x = -1 if is_facing_left else 1
		
		
func flip_back_to_player():
	var player = Utils.get_player()
	
	if player == null:
		return
		
	var direction: Vector2 = global_position.direction_to(player.global_position)
	
	flip(direction.x > 0)
		
		
func flip_sprite_based_on_velocity():
	if velocity.x > 0:
		flip(false)
	elif velocity.x < 0:
		flip(true)
	
	
func on_realod_timer_timeout():
	can_attack = true
	
	
func on_wander_direction_timer_timeout():
	can_change_direction = true
	

func on_died():
	state_machine.change_state(state_die)
