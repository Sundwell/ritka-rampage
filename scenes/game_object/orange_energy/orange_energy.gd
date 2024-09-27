extends Node2D

@export var collected_particles: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var floating_text_spawner_component = $FloatingTextSpawnerComponent


func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	
	
func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group('player')
	
	if player == null:
		return
		
	global_position = start_position.lerp(player.global_position, percent)
	
	
func throw_particles():
	var foreground_layer = get_tree().get_first_node_in_group('foreground_layer')
	
	var particles_spawn_position = global_position
	var particles = collected_particles.instantiate() as CPUParticles2D
	
	particles.global_position = particles_spawn_position
	foreground_layer.add_child(particles)
	
	
func collect():
	throw_particles()
	GameEvents.emit_orange_energy_collected(1)
	floating_text_spawner_component.spawn_text('+1', FloatingText.Type.ORANGE_PICK_UP)
	queue_free()
	

func disable_collision():
	collision_shape.disabled = true
	
	
func on_area_entered(area: Area2D):
	Callable(disable_collision).call_deferred()
	animation_player.play('RESET')
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
			.set_ease(Tween.EASE_IN)\
			.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, 'rotation', sprite.rotation + deg_to_rad(360), 0.5)
	tween.tween_property(sprite, 'scale', Vector2.ZERO, 0.25).set_delay(0.25)
	tween.chain()
	tween.tween_callback(collect)
	
