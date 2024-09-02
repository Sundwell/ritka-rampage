extends CharacterBody2D

@onready var weapon = $Weapon
@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const RUN_SPEED := 125.0
const MOVE_SPEED := 50.0
const ACCELERATION_SMOOTHING := 15

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
	
	var target_velocity = direction.normalized() * (MOVE_SPEED if is_shooting else RUN_SPEED)
	velocity = velocity.lerp(target_velocity, 1.0 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()
	
	flip()
		
	if direction.length() > 0:
		if is_shooting:
			weapon.visible = true
			sprite.play('walk')
		else:
			weapon.visible = false
			sprite.play("run")
		
	else:
		weapon.visible = true
		sprite.play("idle")


func flip():
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false
