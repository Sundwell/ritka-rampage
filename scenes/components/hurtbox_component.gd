class_name HurtboxComponent
extends Area2D

signal got_hurt

@export var health_component: HealthComponent


func _ready():
	area_entered.connect(on_area_entered)


func apply_damage(hitbox_component: HitboxComponent):
	if hitbox_component.is_active:
		health_component.damage(hitbox_component.damage)
		hitbox_component.start_reloading()

	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox = other_area as HitboxComponent
	
	apply_damage(hitbox)
	
