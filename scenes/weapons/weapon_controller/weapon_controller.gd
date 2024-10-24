class_name WeaponContoller
extends Node2D

var weapon: Weapon

@onready var weapon_position: Node2D = $WeaponPosition


func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	weapon_position.scale.y = -1 if abs(global_rotation_degrees) >= 90 else 1
	
	
func shoot():
	if weapon is Weapon:
		weapon.shoot()
		
		
func set_weapon(new_weapon_scene: PackedScene):
	if weapon != null:
		weapon_position.remove_child(weapon)
		return
	
	weapon = new_weapon_scene.instantiate()
	
	if weapon is not Weapon:
		return
	
	weapon.global_rotation = global_rotation
	weapon_position.add_child(weapon)
	
	GameEvents.emit_weapon_changed(weapon)
