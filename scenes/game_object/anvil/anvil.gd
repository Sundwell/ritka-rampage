extends Node2D


func _ready() -> void:
	$Area2D.body_entered.connect(on_body_entered)


func on_body_entered(body: CharacterBody2D):
	GameEvents.emit_anvil_collected()
	queue_free()
