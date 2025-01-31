class_name ProjectileHurtboxComponent
extends Area2D

signal collided(other: Node2D)


func _ready() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	
func on_area_entered(other_area: Area2D):
	collided.emit(other_area)
	
	
func on_body_entered(other_body: Node2D):
	collided.emit(other_body)
