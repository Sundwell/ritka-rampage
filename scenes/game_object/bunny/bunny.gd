extends CharacterBody2D

const SPEED := 180.0
const JUMP_DISTANCE := 60.0

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var sprite: Sprite2D = $Sprite2D

@export var damage_particles_scene: PackedScene
var jumped_distance := 0.0
var is_jumping := false
var jump_direction : Vector2


func _ready():
	hurtbox_component.damaged.connect(on_damaged)
	hitbox_component.damage = 4.0
	%ActionsAnimationPlayer.play('jump')


func _physics_process(delta):
	if is_jumping:
		velocity = jump_direction * SPEED
		jumped_distance += SPEED * delta
		if jumped_distance >= JUMP_DISTANCE:
			velocity = Vector2.ZERO
			jumped_distance = 0
			is_jumping = false
			%ActionsAnimationPlayer.play('jump')

	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	move_and_slide()


func on_damaged(damage_amount: float):
	var damage_particles = damage_particles_scene.instantiate() as Node2D
	damage_particles.global_position = global_position
	get_parent().add_child(damage_particles)
	%VisualAnimationPlayer.play('hurt')


func jump():
	var player = get_tree().get_first_node_in_group('player') as Node2D

	if player == null:
		jump_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	else:
		jump_direction = (player.global_position - global_position).normalized()

	is_jumping = true
