extends Node

var SPAWN_RADIUS = int(ProjectSettings.get_setting('display/window/size/viewport_width') / 1.5)

@export var enemy_scene: PackedScene

func _ready():
	$Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout():
	var player = get_tree().get_first_node_in_group('player') as Node2D
	
	if player == null:
		return
		
	var enemy = enemy_scene.instantiate() as Node2D
	var enemy_position = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	enemy.global_position = player.global_position + (enemy_position * SPAWN_RADIUS)
	
	get_parent().add_child(enemy)
		
	
		
		
