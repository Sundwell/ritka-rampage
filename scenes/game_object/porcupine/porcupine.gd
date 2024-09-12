extends CharacterBody2D

enum State {
	MOVE,
	ATTACK,
	DIE
}

const ATTACK_RANGE: float = 120.0
const WANDER_DISTANCE: float = 100.0
const RUN_FROM_PLAYER_DISTANCE: float = 50.0
const MOVE_SPEED: float = 60.0
const RUN_SPEED: float = 90.0

@export var quill_scene: PackedScene
@export var damage_particles_scene: PackedScene
var current_state: State = State.MOVE
var can_attack := true
var is_player_in_attack_range := false
var is_near_player := false
var should_run_from_player := false
var can_change_direction := true

@onready var actions_animation_player = $ActionsAnimationPlayer
@onready var visual_animation_player = $VisualAnimationPlayer
@onready var reload_timer = $ReloadTimer
@onready var wander_direction_timer = $WanderDirectionTimer
@onready var sprite = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var run_particles: CPUParticles2D = %RunParticles


func _ready():
	reload_timer.timeout.connect(on_realod_timer_timeout)
	wander_direction_timer.timeout.connect(on_wander_direction_timer_timeout)
	health_component.damaged.connect(on_damaged)


func _physics_process(delta: float):
	match current_state:
		State.MOVE:
			update_player_proximity()
			
			if is_near_player and can_attack:
				current_state = State.ATTACK
			else:
				move()
		State.ATTACK:
			velocity = Vector2.ZERO
			actions_animation_player.play('attack')
			
	if should_run_from_player:
		run_particles.emitting = true
	else:
		run_particles.emitting = false
		
	flip()
	move_and_slide()


func shoot():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		return
		
	var quill_count = randi_range(1, 3)
	var direction_to_player: Vector2 = global_position.direction_to(player.global_position)
	
	for index in quill_count:
		var quill = quill_scene.instantiate() as Node2D
		
		var random_angle = deg_to_rad(randf_range(30, -30))
		var random_direction = direction_to_player.rotated(random_angle)
		
		quill.rotation = random_direction.angle()
		quill.global_position = global_position
		get_parent().add_child(quill)
	
	can_attack = false
	current_state = State.MOVE
	reload_timer.start()
	
	
func update_player_proximity():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if not player:
		return

	var distance_to_player: float = global_position.distance_squared_to(player.global_position)
	
	is_near_player = distance_to_player <= pow(WANDER_DISTANCE, 2)
	is_player_in_attack_range = distance_to_player <= pow(ATTACK_RANGE, 2)
	should_run_from_player = distance_to_player <= pow(RUN_FROM_PLAYER_DISTANCE, 2)


func move():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if not player:
		return
		
	actions_animation_player.play('move')
		
	if not is_near_player:
		var direction: Vector2 = global_position.direction_to(player.global_position)
		
		velocity = direction * MOVE_SPEED
	elif can_change_direction:
		var direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
		
		if should_run_from_player:
			direction = -global_position.direction_to(player.global_position)
			velocity = direction * RUN_SPEED
		else:
			velocity = direction * MOVE_SPEED

		can_change_direction = false
		wander_direction_timer.start()
	
	
func flip():
	if velocity.x > 0:
		sprite.flip_h = false
		sprite.offset.x = sprite.offset.x if sprite.offset.x < 0 else -sprite.offset.x
	elif velocity.x < 0:
		sprite.flip_h = true
		sprite.offset.x = abs(sprite.offset.x)
	
	
func on_realod_timer_timeout():
	can_attack = true
	
	
func on_wander_direction_timer_timeout():
	can_change_direction = true
	
	
func on_damaged():
	var damage_particles = damage_particles_scene.instantiate() as Node2D
	damage_particles.global_position = global_position
	get_parent().add_child(damage_particles)
	visual_animation_player.play('hurt')