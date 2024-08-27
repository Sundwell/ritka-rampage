extends Node

@export_range(0, 1) var drop_chance := 0.5
@export var orange_scene: PackedScene
@export var health_component: HealthComponent

func _ready():
	health_component.died.connect(on_died)
	
	
func on_died():
	if randf() > drop_chance:
		return
	
	if orange_scene == null:
		return
		
	if not owner is Node2D:
		return
		
	var orange_spawn_position = (owner as Node2D).global_position
	var orange = orange_scene.instantiate() as Node2D
	orange.global_position = orange_spawn_position
	owner.get_parent().add_child(orange)
	
