class_name HealthComponent
extends Node

signal died
signal damaged(amount: float)

@export var max_health: float = 10.0
var current_health: float


func _ready():
	current_health = max_health


func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	damaged.emit(damage_amount)
	Callable(check_death).call_deferred()
	
	
func get_health_percent():
	if current_health <= 0:
		return 0
	
	return min(current_health / max_health, 1)


func check_death():
	if current_health == 0:
		died.emit()
