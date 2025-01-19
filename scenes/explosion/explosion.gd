class_name Explosion
extends Node2D

var damage: float = 0.0

@onready var hitbox_component: HitboxComponent = $HitboxComponent
@onready var explode_sound: AudioStreamPlayer2D = $ExplodeSound


func _ready() -> void:
	hitbox_component.damage = damage
	explode_sound.pitch_scale = randf_range(1, 1.1)
	
	
func set_damage(amount: float):
	damage = amount
