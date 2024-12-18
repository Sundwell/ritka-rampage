class_name ProjectileHurtboxComponent
extends Area2D

signal collided


func _ready() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	
	
func on_area_entered(other_area: Area2D):
	collided.emit()
	
	
func on_body_entered(other_body):
	collided.emit()
