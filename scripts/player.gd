extends CharacterBody2D

signal player_died

@onready var weapon = $Weapon

const RUN_SPEED := 100.0
const MOVE_SPEED := 30.0

var is_shooting := false
var damage_rate := 10.0
var health := 100.0

func _physics_process(delta):
	if Input.is_action_pressed('fire'):
		is_shooting = true
		%Weapon.shoot()
	else:
		is_shooting = false
	
	var direction = Input.get_vector('move_left', 'move_right', 'move_top', 'move_down')
	velocity = direction.normalized() * (MOVE_SPEED if is_shooting else RUN_SPEED)
	
	move_and_slide()
	
	flip()
		
	if velocity.length() > 0:
		if is_shooting:
			weapon.visible = true
			$AnimatedSprite2D.play('walk')
		else:
			weapon.visible = false
			$AnimatedSprite2D.play("run")
		
	else:
		weapon.visible = true
		$AnimatedSprite2D.play("idle")
		
	var enemy_count_near = %HurtBox.get_overlapping_bodies().size()
	health -= enemy_count_near * damage_rate * delta
	%HealthBar.value = health
	
	if health <= 0:
		player_died.emit()
		
func flip():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
