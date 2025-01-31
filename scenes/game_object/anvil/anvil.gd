extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	GameEvents.emit_anvil_spawned()
	$Area2D.body_entered.connect(on_body_entered)
	animation_player.play("spawn")
	animation_player.queue("idle")


func on_body_entered(body: CharacterBody2D):
	GameEvents.emit_anvil_collected()
	queue_free()
