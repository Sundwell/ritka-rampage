class_name HealthComponent
extends Node

signal died
signal damaged(amount: float)

@export var max_health: float = 10.0
@export var enable_floating_text := true
var current_health: float
var is_dead: bool:
	get():
		return current_health <= 0


func _ready():
	set_max_health(max_health)
	
	
func set_max_health(value: float):
	max_health = value
	current_health = max_health


func _spawn_floating_text(amount: float, type: FloatingText.Type):
	if not enable_floating_text:
		return

	var parent = get_parent()
	if parent is Node2D:
		FloatingTextManager.spawn_text(str(amount), parent.global_position, type)


func damage(damage_amount: float):
	if is_dead:
		return
	
	current_health = max(current_health - damage_amount, 0)
	damaged.emit(damage_amount)
	
	_spawn_floating_text(damage_amount, FloatingText.Type.DAMAGE)
	
	# call deferred due to some stuff happening in-between frames
	# for example removing nodes, changing physics layers, add_child()
	Callable(check_death).call_deferred()
	
	
func heal(heal_amount: float):
	if is_dead:
		return
		
	current_health = min(max_health, current_health + heal_amount)
	
	_spawn_floating_text(heal_amount, FloatingText.Type.HEAL)
	
	
func get_health_percent():
	if current_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
