extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var damage_particles_scene: PackedScene
var tween: Tween


func _ready():
	health_component.damaged.connect(on_damaged)
	
	
func on_damaged(amount: float):
	var initial_modulate = sprite.modulate
	tween = get_tree().create_tween()
	tween.tween_property(sprite, 'modulate', Color('#ff3636'), 0.05)
	tween.tween_property(sprite, 'modulate', initial_modulate, 0.05)
	
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer')
	
	var particles_spawn_position = global_position
	var damage_particles = damage_particles_scene.instantiate() as Node2D
	damage_particles.global_position = particles_spawn_position
	foreground_layer.add_child(damage_particles)