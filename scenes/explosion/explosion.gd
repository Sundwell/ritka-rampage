class_name Explosion
extends Node2D

var damage: float = 0.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent


func _ready() -> void:
	hitbox_component.damage = damage
	
	
func set_damage(amount: float):
	damage = amount
