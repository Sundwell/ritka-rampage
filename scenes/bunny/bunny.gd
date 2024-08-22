extends CharacterBody2D

var player

const SPEED := 180.0
const JUMP_DISTANCE := 60.0
var jumped_distance := 0.0
var health := 3
var is_jumping := false
var jump_direction : Vector2

func _ready():
	player = get_tree().get_first_node_in_group('player')
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
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
	
	move_and_slide()
	
func take_damage():
	health -= 1
	%VisualAnimationPlayer.play('hurt')
	
	if health <= 0:
		queue_free()
		
func jump():
	jump_direction = global_position.direction_to(player.global_position)
	is_jumping = true
