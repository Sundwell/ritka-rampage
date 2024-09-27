extends Node2D

@export var health_component: HealthComponent

@onready var floating_text_spawner_component = $FloatingTextSpawnerComponent


func _ready():
	health_component.damaged.connect(on_damaged)
	
	
func spawn_text(text: String, type: FloatingText.Type):
	floating_text_spawner_component.spawn_text(text, type)
	
	
func on_damaged(amount: float):
	spawn_text(str(amount), FloatingText.Type.DAMAGE)
