extends Area2D

var travelled_distance := 0
const SPEED = 250
const MAX_DISTANCE = 100

func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	if travelled_distance >= MAX_DISTANCE:
		queue_free()


func _on_body_entered(body):
	queue_free()
	
	if body.has_method('take_damage'):
		body.take_damage()
