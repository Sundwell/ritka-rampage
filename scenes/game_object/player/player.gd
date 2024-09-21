extends CharacterBody2D

@onready var weapon = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const RUN_SPEED := 125.0
const BASE_MOVE_SPEED := 50.0
const ACCELERATION_SMOOTHING := 15

var is_shooting := false
var damage_rate := 10.0
var health := 100.0
var mutations: Dictionary = {}
var move_speed := 50.0
var state_machine := CallableStateMachine.new()


func _ready():
	GameEvents.mutation_upgrade_selected.connect(on_mutation_upgrade_selected)
	
	state_machine.add_states(state_idle, enter_state_idle)
	state_machine.add_states(state_moving)
	state_machine.set_initial_state(state_idle)
	

func _physics_process(delta: float):
	state_machine.update()
	
	move_and_slide()
		
		
func shoot():
	if Input.is_action_pressed('fire'):
		is_shooting = true
		weapon.shoot()
	else:
		is_shooting = false
		
		
func flip():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
		
		
func get_movement_direction() -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_top', 'move_down')
		
		
func move():
	var direction = get_movement_direction()
	
	var speed = move_speed if is_shooting else RUN_SPEED
	
	var target_velocity = direction.normalized() * speed
	velocity = velocity.lerp(target_velocity, 1.0 - exp(-ACCELERATION_SMOOTHING * get_physics_process_delta_time()))
		
		
func enter_state_idle():
	sprite.play('idle')
	velocity = Vector2.ZERO
	weapon.visible = true
		
		
func state_idle():
	shoot()
	
	if get_movement_direction().length() > 0:
		state_machine.change_state(state_moving)
	
	
func state_moving():
	shoot()
	move()
	flip()
	
	if get_movement_direction().length() == 0:
		state_machine.change_state(state_idle)
		return
		
	if mutations.has("run_while_shooting"):
		weapon.visible = true
		sprite.play("run")
	else:
		if is_shooting:
			weapon.visible = true
			sprite.play("walk")
		else:
			weapon.visible = false
			sprite.play("run")
		
		
func on_mutation_upgrade_selected(upgrade: MutationUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "run_while_shooting":
		mutations["run_while_shooting"] = true
		move_speed = RUN_SPEED
