extends Node2D

func _on_area_2d_body_entered(_body):
	$AnimatedSprite2D.play('watching')


func _on_area_2d_body_exited(_body):
	$AnimatedSprite2D.play('idle')
