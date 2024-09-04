extends CPUParticles2D


func _ready():
	finished.connect(on_finished)
	emitting = true
	
	
func on_finished():
	queue_free()
	
	
