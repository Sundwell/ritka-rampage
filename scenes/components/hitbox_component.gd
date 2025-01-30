class_name HitboxComponent
extends Area2D

@export var reload_time: float = 0.5
@export var damage := 0.0
var statuses: Array[Status]
var collision_nodes: Array[Node] = []
var is_active := true

@onready var timer: Timer = $Timer


func _ready():
	if reload_time > 0:
		timer.wait_time = reload_time
		timer.timeout.connect(_on_reload_timeout)
		
	collision_nodes = Utils.get_children_of_type(self, CollisionShape2D)


func _toggle_collisions(disabled: bool):
	is_active = not disabled
	for collision: CollisionShape2D in collision_nodes:
		collision.set_deferred('disabled', disabled)
		
		
func add_status(status: Status):
	statuses.append(status)
	
	
func clear_statuses():
	statuses.clear()


func start_reloading():
	if reload_time == 0.0:
		return
		
	_toggle_collisions(true)
	
	timer.start()


func _on_reload_timeout():
	_toggle_collisions(false)
