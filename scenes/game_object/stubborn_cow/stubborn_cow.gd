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
const CONTACT_DAMAGE = 4.0

@export var damage_particles_scene: PackedScene
var current_state: State = State.MOVE

@onready var actions_animation_player = $ActionsAnimationPlayer
@onready var visual_animation_player = $VisualAnimationPlayer
@onready var sprite = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready():
	health_component.damaged.connect(on_damaged)
	hitbox_component.damage = CONTACT_DAMAGE


func _physics_process(delta):
	match current_state:
		State.MOVE:
			move()
			flip()
			
	move_and_slide()


func move():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if not player:
		return
		
	actions_animation_player.play('move')
	
	var direction: Vector2 = global_position.direction_to(player.global_position)
	
	velocity = WALK_SPEED * direction


func flip():
	if velocity.x > 0:
		sprite.flip_h = false
	elif velocity.x < 0:
		sprite.flip_h = true


func on_damaged():
	var damage_particles = damage_particles_scene.instantiate() as Node2D
	damage_particles.global_position = global_position
	get_parent().add_child(damage_particles)
	visual_animation_player.play('hurt')
