extends CharacterBody2D

enum State {
	MOVE,
	PREPARE_ATTACK,
	BULL_RUSH_ATTACK,
	DIE
}

const WALK_SPEED = 50.0
const BULL_RUSH_SPEED = 180.0
const BULL_RUSH_DAMAGE = 16.0
const BULL_RUSH_MAX_DISTANCE = 200.0
const CONTACT_DAMAGE = 4.0
const MIN_BULL_RUSH_START_DISTANCE = 120.0
const KEEP_DIRECTION_DISTANCE = 10.0

@export var damage_particles_scene: PackedScene
@export var prepare_attack_particles: PackedScene
var current_state: State = State.MOVE
var is_bull_rush_ready := false
var bull_rush_direction: Vector2
var bull_rush_travelled_distance := 0.0

@onready var actions_animation_player := $ActionsAnimationPlayer
@onready var visual_animation_player := $VisualAnimationPlayer
@onready var sprite := $Sprite2D
@onready var ground_shadow := %GroundShadow
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var bull_rush_cooldown_timer := $BullRushCooldownTimer


func _ready():
	health_component.damaged.connect(on_damaged)
	hitbox_component.damage = CONTACT_DAMAGE
	bull_rush_cooldown_timer.timeout.connect(on_bull_rush_colldown_timer_timeout)
	bull_rush_cooldown_timer.start()


func _physics_process(delta):
	match current_state:
		State.MOVE:
			move()
			flip()
		State.PREPARE_ATTACK:
			pass
		State.BULL_RUSH_ATTACK:
			bull_rush(delta)
			flip()
			
	move_and_slide()


func move():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if not player:
		return
		
	if is_bull_rush_ready and can_start_bull_rush():
		prepare_bull_rush()
		return
		
	actions_animation_player.play('move')
	
	if get_distance_to_player() <= KEEP_DIRECTION_DISTANCE:
		return
	
	var direction: Vector2 = global_position.direction_to(player.global_position)
	
	velocity = WALK_SPEED * direction


func flip():
	if velocity.x > 0:
		sprite.flip_h = false
		ground_shadow.position.x = -2
	elif velocity.x < 0:
		sprite.flip_h = true
		ground_shadow.position.x = 2


func create_prepare_attack_particles():
	var particles = prepare_attack_particles.instantiate() as CPUParticles2D
	particles.global_position = global_position
	particles.direction.x = 1 if sprite.flip_h else -1
	get_parent().add_child(particles)


func prepare_bull_rush():
	velocity = Vector2.ZERO
	bull_rush_travelled_distance = 0.0
	actions_animation_player.play('prepare_attack')
	current_state = State.PREPARE_ATTACK
	
	
func start_bull_rush():
	is_bull_rush_ready = false
	bull_rush_cooldown_timer.start()
	
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if not player:
		return
		
	actions_animation_player.play('bull_rush')
	current_state = State.BULL_RUSH_ATTACK
	hitbox_component.damage = BULL_RUSH_DAMAGE
	bull_rush_direction = global_position.direction_to(player.global_position)
	

func bull_rush(delta: float):
	velocity = bull_rush_direction * BULL_RUSH_SPEED
	bull_rush_travelled_distance += delta * BULL_RUSH_SPEED
	
	if bull_rush_travelled_distance >= BULL_RUSH_MAX_DISTANCE:
		current_state = State.MOVE
		hitbox_component.damage = CONTACT_DAMAGE
	
	
func can_start_bull_rush():
	var distance = get_distance_to_player()
	
	return distance >= MIN_BULL_RUSH_START_DISTANCE
	
	
func get_distance_to_player():
	var player = get_tree().get_first_node_in_group('player') as Node2D
		
	if not player:
		return
		
	var distance = global_position.distance_to(player.global_position)
	
	return distance

func on_damaged(damage_amount: float):
	var damage_particles = damage_particles_scene.instantiate() as Node2D
	damage_particles.global_position = global_position
	get_parent().add_child(damage_particles)
	visual_animation_player.play('hurt')
	
	
func on_bull_rush_colldown_timer_timeout():
	is_bull_rush_ready = true
