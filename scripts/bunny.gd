extends CharacterBody2D

var player

const SPEED := 55
var health := 3

func _ready():
	player = get_tree().get_first_node_in_group('Player')

func _physics_process(_delta):
	var direction = global_position.direction_to(player.global_position)
	
	var close_to_player := roundf(abs(global_position.length() - player.global_position.length())) < 4
	
	if not close_to_player:
		velocity = direction * SPEED
	
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
