extends Node2D

var bullet_scene := preload("res://scenes/pistol_bullet.tscn")
var can_shoot := true

func _physics_process(_delta):
	look_at(get_global_mouse_position())
	
	var processed_rotation_degrees = abs(int(global_rotation_degrees) % 180)
	var should_flip = processed_rotation_degrees < 180 and processed_rotation_degrees > 90
	
	%WeaponSprite.flip_v = should_flip
	
func shoot():
	if not can_shoot:
		return

	can_shoot = false
	%Reload.start()
	var bullet = bullet_scene.instantiate()
	
	bullet.position = %ShootPosition.global_position
	bullet.rotation = %ShootPosition.global_rotation
	
	get_parent().add_child(bullet)

func _on_reload_timeout():
	can_shoot = true
