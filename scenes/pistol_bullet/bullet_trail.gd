extends Line2D

func _physics_process(_delta):
	add_point(get_parent().global_position)
	
	if points.size() >= 10:
		remove_point(0)
