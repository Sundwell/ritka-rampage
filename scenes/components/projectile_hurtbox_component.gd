extends Area2D

@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area: Area2D):
	if health_component == null:
		return
	
	health_component.damage(1)
	
