class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent
@export var status_manager: StatusManager


func _ready():
	area_entered.connect(on_area_entered)


func apply_damage(hitbox_component: HitboxComponent):
	if hitbox_component.is_active:
		health_component.damage(hitbox_component.damage)
		hitbox_component.start_reloading()
		
		if status_manager:
			for status in hitbox_component.statuses:
				status_manager.add_status(status.duplicate())

	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox = other_area as HitboxComponent
	
	apply_damage(hitbox)
	
