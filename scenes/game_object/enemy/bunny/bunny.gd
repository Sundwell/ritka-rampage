extends CharacterBody2D

const JUMP_DISTANCE := 60.0

var speed := 180.0
var jumped_distance := 0.0
var is_jumping := false
var state_machine := CallableStateMachine.new()

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var visuals: Node2D = $Visuals
@onready var actions_animation_player = $ActionsAnimationPlayer
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _ready():
	speed = velocity_component.max_speed
	velocity_component.max_speed = speed
	
	state_machine.add_states(state_jumping, Callable(), exit_state_jumping)
	state_machine.add_states(state_jump_preparation, enter_state_jump_preparation)
	state_machine.add_states(state_die, enter_state_die)
	state_machine.set_initial_state(state_jump_preparation)
	
	$HealthComponent.died.connect(on_died)


func _physics_process(delta: float):
	state_machine.update()


func enter_state_jump_preparation():
	actions_animation_player.play('jump')


func state_jump_preparation():
	pass


func state_jumping():
	velocity_component.move()
	
	jumped_distance += speed * get_physics_process_delta_time()
	
	if jumped_distance >= JUMP_DISTANCE:
		state_machine.change_state(state_jump_preparation)
		
	if velocity.x < 0:
		visuals.scale.x = -1
	elif velocity.x > 0:
		visuals.scale.x = 1
		
		
func exit_state_jumping():
	jumped_distance = 0
	velocity = Vector2.ZERO


func enter_state_die():
	GameEvents.emit_enemy_died()
	$HitboxComponent.queue_free()
	$CollisionShape2D.queue_free()
	actions_animation_player.play('die')


func state_die():
	pass


func jump():
	velocity_component.accelerate_to_player()
	var player = Utils.get_player()
	var jump_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))

	if player == null:
		velocity_component.accelerate_in_direction(jump_direction)
		
	state_machine.change_state(state_jumping)
	
	
func on_died():
	state_machine.change_state(state_die)
