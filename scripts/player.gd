extends CharacterBody2D

@onready var weapon = $Weapon

const RUN_SPEED := 100
const MOVE_SPEED := 30

var damage_rate := 5.0
var can_shoot := true
var health := 100.0

func _physics_process(delta):
	if Input.is_action_pressed('fire') and can_shoot:
		%Weapon.shoot()
	
	var direction = Input.get_vector('move_left', 'move_right', 'move_top', 'move_down')
	velocity = direction * RUN_SPEED
	
	move_and_slide()
	
	flip()
		
	if velocity.length() > 0:
		can_shoot = false
		weapon.visible = false
		$AnimatedSprite2D.play("run")
	else:
		can_shoot = true
		weapon.visible = true
		$AnimatedSprite2D.play("idle")
		
	var enemy_count_near = %HurtBox.get_overlapping_bodies().size()
	health -= enemy_count_near * damage_rate * delta
	%HealthBar.value = health
		
func flip():
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
	
