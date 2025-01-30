extends CharacterBody2D

@export var available_textures: Array[Texture]
var is_dead := false

@onready var sprite: Sprite2D = %Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var spawn_sound: AudioStreamPlayer2D = $SpawnSound


func _ready() -> void:
	sprite.texture = available_textures.pick_random()
	health_component.died.connect(_on_died)
	spawn_sound.pitch_scale = randf_range(0.95, 1.05)


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	velocity_component.accelerate_to_player()
	velocity_component.move()
	visuals.scale.x = -1 if velocity.x < 0 else 1


func _on_died() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	hitbox_component.queue_free()
	hurtbox_component.queue_free()
	animation_player.play('die')
	await animation_player.animation_finished
	queue_free()
