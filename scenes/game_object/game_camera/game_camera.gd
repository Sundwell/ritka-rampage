extends Camera2D

var target_position := Vector2.ZERO


func _ready():
	make_current()
	
	
func _physics_process(delta):
	acquire_target()
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 15))
	
	
func acquire_target():
	var player = Utils.get_player()
	
	if player != null:
		target_position = player.global_position
