extends Node2D

@export var soul_texture: Texture2D
@export var health_component: HealthComponent
var is_died := false

@onready var particles = $CPUParticles2D
@onready var animation_player = $AnimationPlayer


func _ready():
	particles.texture = soul_texture
	health_component.died.connect(on_died)


func on_died():
	if is_died:
		return
		
	is_died = true
	var entities_layer = get_tree().get_first_node_in_group(Constants.GROUPS.ENTITIES_LAYER)
	var spawn_position = owner.global_position
	
	get_parent().remove_child(self)
	entities_layer.add_child(self)
	
	global_position = spawn_position
	
	animation_player.play('default')
