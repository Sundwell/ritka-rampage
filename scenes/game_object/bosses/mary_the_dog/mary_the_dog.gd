extends CharacterBody2D

@export var tick_status_scene: PackedScene
@export var puppy_scene: PackedScene
@export var anvil_scene: PackedScene
@export var available_textures: Array[Texture]
var state_machine := CallableStateMachine.new()

@onready var velocity_component: VelocityComponent = $VelocityComponent
@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var heal_timer: Timer = $HealTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var bite_hitbox_component: HitboxComponent = %BiteHitboxComponent
@onready var bite_collision: CollisionShape2D = %BiteHitboxComponent/BiteCollision
@onready var bite_direction_marker: Marker2D = $BiteDirectionMarker
@onready var base_collision: CollisionShape2D = $BaseCollision
@onready var summon_timer: Timer = $SummonTimer
@onready var puppy_spawn_timer: Timer = $PuppySpawnTimer
@onready var sprite: Sprite2D = %Sprite2D


func _ready():
	heal_timer.timeout.connect(_on_heal_timer_timeout)
	health_component.died.connect(_on_died)
	summon_timer.timeout.connect(_on_summon_timeout)
	puppy_spawn_timer.timeout.connect(_on_puppy_spawn_timeout)
	
	sprite.texture = available_textures.pick_random()
	
	var tick_status: TickStatus = tick_status_scene.instantiate()
	tick_status.setup(hitbox_component.damage / 4, 3.0)
	bite_hitbox_component.add_status(tick_status)
	
	state_machine.add_states(state_running, enter_state_running)
	state_machine.add_states(state_die, enter_state_die)
	state_machine.add_states(state_biting, enter_state_biting)
	state_machine.set_initial_state(state_running)
	
	
func _physics_process(delta: float):
	state_machine.update()


func move():
	velocity_component.accelerate_to_player()
	velocity_component.move()
	visuals.scale.x = -1 if velocity.x < 0 else 1


func enter_state_running():
	animation_player.play('run')
	
	
func _can_bite():
	var player: Node2D = Utils.get_player()
	var distance_to_player: float = base_collision.global_position.distance_to(player.global_position)
	
	if distance_to_player <= (bite_collision.shape as CircleShape2D).radius * 1.5:
		return true
		
	return false
	
	
func state_running():
	move()
	
	if _can_bite():
		state_machine.change_state(state_biting)
	
	
func bite():
	var player: Node2D = Utils.get_player()
	var angle_to_player: float = global_position.angle_to_point(player.global_position)
	bite_direction_marker.rotation = angle_to_player
	animation_player.play('bite')
		
		
func try_bite_again():
	if _can_bite():
		bite()
	else:
		state_machine.change_state(state_running)
	

func enter_state_biting():
	velocity = Vector2.ZERO
	bite()


func state_biting():
	pass


func state_die(): pass


func enter_state_die():
	velocity = Vector2.ZERO
	var anvil: Node2D = anvil_scene.instantiate()
	anvil.global_position = global_position
	Utils.get_entities_layer().add_child(anvil)
	heal_timer.stop()
	summon_timer.stop()
	hitbox_component.queue_free()
	hurtbox_component.queue_free()
	animation_player.play('die')
	await animation_player.animation_finished
	GameEvents.emit_enemy_died()
	queue_free()
	
	
func _on_heal_timer_timeout():
	if health_component.current_health != health_component.max_health:
		health_component.heal(1)
		
		
func _on_died():
	state_machine.change_state(state_die)
	
	
func _on_summon_timeout():
	for puppy in range(3):
		puppy_spawn_timer.start()
		await puppy_spawn_timer.timeout


func _on_puppy_spawn_timeout():
	var puppy: Node2D = puppy_scene.instantiate()
	puppy.global_position = global_position
	
	var entities_layer = Utils.get_entities_layer()
	entities_layer.add_child(puppy)
