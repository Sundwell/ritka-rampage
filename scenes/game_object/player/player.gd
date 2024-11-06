extends CharacterBody2D

const RUN_SPEED = 125.0
const BASE_MOVE_SPEED = 50.0
const ACCELERATION_SMOOTHING = 15

@export var initial_weapon_scene: PackedScene

var is_shooting := false
var mutations: Dictionary = {}
var move_speed := BASE_MOVE_SPEED
var state_machine := CallableStateMachine.new()

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var weapon_controller: WeaponContoller = $WeaponController
@onready var velocity_component: VelocityComponent = $VelocityComponent


func _ready():
	GameEvents.mutation_upgrade_selected.connect(on_mutation_upgrade_selected)
	
	state_machine.add_states(state_idle, enter_state_idle)
	state_machine.add_states(state_moving)
	state_machine.set_initial_state(state_idle)
	
	weapon_controller.set_weapon(initial_weapon_scene)
	

func _physics_process(delta: float):
	state_machine.update()
	shoot()
		
		
func shoot():
	if Input.is_action_pressed('fire'):
		is_shooting = true
		weapon_controller.shoot()
	else:
		is_shooting = false
		
		
func flip():
	if velocity.x < 0:
		visuals.scale.x = -1
	elif velocity.x > 0:
		visuals.scale.x = 1
		
		
func get_movement_direction() -> Vector2:
	return Input.get_vector('move_left', 'move_right', 'move_top', 'move_down')
		
		
func move():
	var direction = get_movement_direction()
	
	var speed: float = move_speed if is_shooting else RUN_SPEED
	
	velocity_component.max_speed = speed
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move()
		

#region States
func enter_state_idle():
	animation_player.play("idle")
	velocity_component.stop()
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
		
	if is_shooting:
		weapon_controller.visible = true
		animation_player.play("walk")
	else:
		weapon_controller.visible = false
		animation_player.play("run")
#endregion


func apply_mutation(mutation: MutationUpgrade):
	match mutation.id:
		MutationUpgrade.Id.SPEED_UP:
			var speed_up_count: int = Utils.get_upgrade_quantity(mutations, MutationUpgrade.Id.SPEED_UP)
			move_speed = BASE_MOVE_SPEED + ((BASE_MOVE_SPEED * 0.1) * speed_up_count)
	


func on_mutation_upgrade_selected(mutation: MutationUpgrade, current_mutations: Dictionary):
	mutations = current_mutations.duplicate()
	apply_mutation(mutation)
