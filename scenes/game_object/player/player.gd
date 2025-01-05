extends CharacterBody2D

const BASE_RUN_SPEED = 125.0
const BASE_MOVE_SPEED = 50.0
const ACCELERATION_SMOOTHING = 15

@export var initial_weapon_scene: PackedScene

var is_shooting := false
var mutations_count: Dictionary = {}
var weapon_upgrades_count: Dictionary = {}
var run_speed := BASE_RUN_SPEED
var move_speed := BASE_MOVE_SPEED
var state_machine := CallableStateMachine.new()

@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var weapon_controller: WeaponContoller = $WeaponController
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var shooting_state_change_timer: Timer = $ShootingStateChangeTimer


func _ready():
	GameEvents.mutation_upgrade_selected.connect(_on_mutation_upgrade_selected)
	GameEvents.weapon_upgrade_selected.connect(_on_weapon_upgrade_selected)
	
	state_machine.add_states(state_idle, enter_state_idle, exit_state_idle)
	state_machine.add_states(state_moving)
	state_machine.set_initial_state(state_idle)
	
	weapon_controller.set_weapon(initial_weapon_scene)
	

func _physics_process(delta: float):
	state_machine.update()
	shoot()
		
		
func shoot():
	if Input.is_action_pressed('fire'):
		shooting_state_change_timer.start()
		is_shooting = true
		weapon_controller.shoot()
	elif shooting_state_change_timer.is_stopped():
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
	
	var speed: float = move_speed if is_shooting else run_speed
	
	velocity_component.max_speed = speed
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move()
		

#region States
func exit_state_idle():
	shooting_state_change_timer.stop()


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


func _update_mutations_count(mutations: Dictionary):
	const MUTATION_IDS = [
		MutationUpgrade.Id.SPEED_UP
	]
	
	for id in MUTATION_IDS:
		mutations_count[id] = Utils.get_upgrade_quantity(mutations, id)
	
	
func _update_weapon_upgrades_count(upgrades: Dictionary):
	const UPGRADE_IDS = [
		PistolUpgrade.Id.BLOODY_BURDEN,
	]
	
	for id in UPGRADE_IDS:
		weapon_upgrades_count[id] = Utils.get_upgrade_quantity(upgrades, id)


func _update_movement_speed():
	var speed_up_count: int = mutations_count.get(MutationUpgrade.Id.SPEED_UP, 0)
	var bloody_burden_count: int = weapon_upgrades_count.get(PistolUpgrade.Id.BLOODY_BURDEN, 0)
	var speed_multiplier: float = 1.0 + ((BASE_MOVE_SPEED * 0.1) * speed_up_count)
	
	if bloody_burden_count > 0:
		speed_multiplier *= 0.8
		
	move_speed = BASE_MOVE_SPEED * speed_multiplier
	run_speed = BASE_RUN_SPEED * speed_multiplier
	
	
func _apply_mutations():
	var speed_up_count: int = mutations_count.get(MutationUpgrade.Id.SPEED_UP, 0)
	if speed_up_count > 0:
		_update_movement_speed()


func _on_mutation_upgrade_selected(mutation: MutationUpgrade, current_mutations: Dictionary):
	mutations_count[mutation.id] = Utils.get_upgrade_quantity(current_mutations, mutation.id)
	_apply_mutations()
	
	
func _on_weapon_upgrade_selected(upgrade: WeaponUpgrade, current_upgrades: Dictionary):
	weapon_upgrades_count[upgrade.get_id()] = Utils.get_upgrade_quantity(current_upgrades, upgrade.get_id())
	
	if upgrade.get_id() == PistolUpgrade.Id.BLOODY_BURDEN:
		_update_movement_speed()
