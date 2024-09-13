extends ProgressBar

@export var health_component: HealthComponent


func _ready():
	health_component.damaged.connect(on_damaged)
	value = health_component.get_health_percent()
	
	
func on_damaged(damage_amount: float):
	value = health_component.get_health_percent()
