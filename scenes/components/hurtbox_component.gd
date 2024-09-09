class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent
@export var has_invinsibility_frames: bool = false
var surrounding_hitboxes: Array[HitboxComponent]


func _ready():
	area_entered.connect(on_area_entered)
	area_exited.connect(on_area_exited)
	
	
func _process(delta):
	if has_invinsibility_frames:
		process_hitboxes()


func process_hitboxes():
	for hitbox_component in surrounding_hitboxes:
		apply_damage(hitbox_component)
			
			
func apply_damage(hitbox_component: HitboxComponent):
	if hitbox_component.is_reloaded():
		health_component.damage(hitbox_component.damage)
		hitbox_component.start_reloading()

	
func on_area_entered(other_area: Area2D):
	if not other_area is HitboxComponent:
		return
	
	if health_component == null:
		return
	
	var hitbox = other_area as HitboxComponent
	
	if has_invinsibility_frames:
		if not surrounding_hitboxes.has(hitbox):
			surrounding_hitboxes.append(hitbox)
	else:
		apply_damage(hitbox)
	
	
func on_area_exited(other_area: Area2D):
	var hitbox_to_remove_index = surrounding_hitboxes.find(other_area)
	
	if hitbox_to_remove_index == -1:
		return
	
	surrounding_hitboxes.remove_at(hitbox_to_remove_index)
