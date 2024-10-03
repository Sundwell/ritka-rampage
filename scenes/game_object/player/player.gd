extends CharacterBody2D

const RUN_SPEED := 125.0
const BASE_MOVE_SPEED := 50.0
const ACCELERATION_SMOOTHING := 15

var is_shooting := false
var mutations: Dictionary = {}
var move_speed := BASE_MOVE_SPEED
var state_machine := CallableStateMachine.new()

@onready var health_component = $HealthComponent
@onready var weapon_controller = $WeaponController
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	GameEvents.mutation_upgrade_selected.connect(on_mutation_upgrade_selected)
	
	state_machine.add_states(state_idle, enter_state_idle)
	state_machine.add_states(state_moving)
	state_machine.set_initial_state(state_idle)
	

func _physics_process(delta: float):
	state_machine.update()
	move_and_slide()
	shoot()
		
		
func shoot():
	if Input.is_action_pressed('fire'):
		is_shooting = true
		weapon_controller.shoot()
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
		

#region States
func enter_state_idle():
	sprite.play('idle')
	velocity = Vector2.ZERO
	weapon_controller.visible = true
		
		
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
		
	if mutations.has(MutationUpgrade.Type.RUN_WHILE_SHOOTING):
		weapon_controller.visible = true
		sprite.play("run")
	else:
		if is_shooting:
			weapon_controller.visible = true
			sprite.play("walk")
		else:
			weapon_controller.visible = false
			sprite.play("run")
#endregion

		
func on_mutation_upgrade_selected(upgrade: MutationUpgrade, current_upgrades: Dictionary):
	if upgrade.id == MutationUpgrade.Type.RUN_WHILE_SHOOTING:
		mutations[MutationUpgrade.Type.RUN_WHILE_SHOOTING] = true
		move_speed = RUN_SPEED
