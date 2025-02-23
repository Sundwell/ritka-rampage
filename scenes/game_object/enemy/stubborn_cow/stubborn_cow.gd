extends CharacterBody2D

const MOVE_SPEED = 50.0
const BULL_RUSH_SPEED = 240.0
const BULL_RUSH_DAMAGE = 10.0
const BULL_RUSH_MAX_DISTANCE = 300.0
const CONTACT_DAMAGE = 6.0
const MIN_BULL_RUSH_START_DISTANCE = 70.0

@export var prepare_attack_particles: PackedScene
var is_bull_rush_ready := false
var bull_rush_direction: Vector2
var bull_rush_travelled_distance := 0.0
var state_machine := CallableStateMachine.new()

@onready var actions_animation_player := $ActionsAnimationPlayer
@onready var visuals := $Visuals
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var bull_rush_cooldown_timer := $BullRushCooldownTimer
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _ready():
	hitbox_component.damage = CONTACT_DAMAGE
	bull_rush_cooldown_timer.timeout.connect(on_bull_rush_colldown_timer_timeout)
	bull_rush_cooldown_timer.start()
	
	state_machine.add_states(state_move)
	state_machine.add_states(state_prepare_attack, enter_state_prepare_attack)
	state_machine.add_states(state_bull_rush, enter_state_bull_rush, exit_state_bull_rush)
	state_machine.add_states(state_die, enter_state_die)
	state_machine.set_initial_state(state_move)
	
	$HealthComponent.died.connect(on_died)


func _physics_process(delta: float):
	state_machine.update()


func state_move():
	if is_bull_rush_ready and can_start_bull_rush():
		state_machine.change_state(state_prepare_attack)
		return

	actions_animation_player.play('move')
	
	velocity_component.accelerate_to_player()
	velocity_component.move()
	
	flip()
	
	
func enter_state_prepare_attack():
	prepare_bull_rush()
	
	
func state_prepare_attack():
	pass
	
	
func enter_state_bull_rush():
	velocity_component.max_speed = BULL_RUSH_SPEED
	
	
func state_bull_rush():
	velocity_component.accelerate_in_direction(bull_rush_direction)
	velocity_component.move()
	
	bull_rush_travelled_distance += get_physics_process_delta_time() * BULL_RUSH_SPEED
	
	if bull_rush_travelled_distance >= BULL_RUSH_MAX_DISTANCE:
		state_machine.change_state(state_move)
	
	flip()
	
	
func exit_state_bull_rush():
	velocity_component.max_speed = MOVE_SPEED
	hitbox_component.damage = CONTACT_DAMAGE
	
	
func enter_state_die():
	GameEvents.emit_enemy_died()
	velocity = Vector2.ZERO
	$HitboxComponent.queue_free()
	$CollisionShape2D.queue_free()
	actions_animation_player.play('die')


func state_die():
	pass


func flip():
	if velocity.x > 0:
		visuals.scale.x = 1
	elif velocity.x < 0:
		visuals.scale.x = -1


func create_prepare_attack_particles():
	var particles = prepare_attack_particles.instantiate() as CPUParticles2D
	particles.global_position = global_position
	particles.direction.x = -visuals.scale.x
	get_parent().add_child(particles)


func prepare_bull_rush():
	velocity = Vector2.ZERO
	bull_rush_travelled_distance = 0.0
	actions_animation_player.play('prepare_attack')
	
	
func start_bull_rush():
	is_bull_rush_ready = false
	bull_rush_cooldown_timer.start()
	
	var player = Utils.get_player()
	
	if player == null:
		state_machine.change_state(state_move)
		return
		
	actions_animation_player.play('bull_rush')
	hitbox_component.damage = BULL_RUSH_DAMAGE
	bull_rush_direction = global_position.direction_to(player.global_position)
	state_machine.change_state(state_bull_rush)
	
	
func can_start_bull_rush():
	var distance = get_distance_to_player()
	
	return distance >= MIN_BULL_RUSH_START_DISTANCE
	
	
func get_distance_to_player():
	var player = Utils.get_player()
		
	if player == null:
		return
		
	var distance = global_position.distance_to(player.global_position)
	
	return distance
	
	
func on_bull_rush_colldown_timer_timeout():
	is_bull_rush_ready = true
	
	
func on_died():
	state_machine.change_state(state_die)
