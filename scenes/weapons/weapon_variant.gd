class_name WeaponVariant
extends Node2D

@export var shoot_position: Marker2D
@export var animation_player: AnimationPlayer 


func get_shoot_position():
	return shoot_position.global_position
