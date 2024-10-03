extends Node2D

@onready var weapon_position: Node2D = $WeaponPosition

@export var weapon_scene: PackedScene
var weapon: Node2D


func _ready():
	weapon = weapon_scene.instantiate()
	weapon.global_rotation = global_rotation
	weapon_position.add_child(weapon)
	
	
func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
	
	weapon_position.scale.y = -1 if abs(global_rotation_degrees) >= 90 else 1
	
	
func shoot():
	if weapon.has_method("shoot"):
		weapon.shoot()
