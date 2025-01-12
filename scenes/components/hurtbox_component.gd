class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent
@export var status_manager: StatusManager


func _ready():
	area_entered.connect(on_area_entered)
	health_component.died.connect(_on_died)


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
	
	
func _on_died():
	var children: Array[Node] = get_children()
	
	for child in children:
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
