extends CharacterBody2D

const SPEED := 180.0
const JUMP_DISTANCE := 60.0

@export var damage_particles_scene: PackedScene
var jumped_distance := 0.0
var is_jumping := false
var jump_direction : Vector2
var state_machine := CallableStateMachine.new()

@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var visuals: Node2D = $Visuals
@onready var actions_animation_player = $ActionsAnimationPlayer


func _ready():
	hitbox_component.damage = 4.0
	
	state_machine.add_states(state_jumping)
	state_machine.add_states(state_jump_preparation, enter_state_jump_preparation)
	state_machine.add_states(state_die, enter_state_die)
	state_machine.set_initial_state(state_jump_preparation)
	
	$HealthComponent.died.connect(on_died)


func _physics_process(delta: float):
	state_machine.update(delta)

	move_and_slide()


func enter_state_jump_preparation():
	actions_animation_player.play('jump')


func state_jump_preparation(delta: float):
	pass


func state_jumping(delta: float):
	velocity = jump_direction * SPEED
	jumped_distance += SPEED * delta
	
	if jumped_distance >= JUMP_DISTANCE:
		velocity = Vector2.ZERO
		jumped_distance = 0
		
		state_machine.change_state(state_jump_preparation)
		
	if velocity.x < 0:
		visuals.scale.x = -1
	elif velocity.x > 0:
		visuals.scale.x = 1


func enter_state_die():
	velocity = Vector2.ZERO
	$HurtboxComponent.queue_free()
	$HitboxComponent.queue_free()
	actions_animation_player.play('die')


func state_die(delta: float):
	pass


func jump():
	var player = get_tree().get_first_node_in_group('player') as Node2D

	if player == null:
		jump_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	else:
		jump_direction = (player.global_position - global_position).normalized()
		
	state_machine.change_state(state_jumping)
	
	
func on_died():
	state_machine.change_state(state_die)
