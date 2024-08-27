extends CharacterBody2D

const SPEED := 180.0
const JUMP_DISTANCE := 60.0

var jumped_distance := 0.0
var is_jumping := false
var jump_direction : Vector2

@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	$Hurtbox.area_entered.connect(_on_hurtbox_area_entered)
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
	
	
func take_damage(damage_amount: float):
	health_component.damage(damage_amount)
	%VisualAnimationPlayer.play('hurt')


func _on_hurtbox_area_entered(area: Area2D):
	take_damage(2)


func jump():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		jump_direction = Vector2.RIGHT.rotated(randf_range(0, TAU))
	else:
		jump_direction = (player.global_position - global_position).normalized()
		
	is_jumping = true
