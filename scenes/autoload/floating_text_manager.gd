extends Node

@export var floating_text_scene: PackedScene


func spawn_text(text: String, spawn_position: Vector2, type: FloatingText.Type = FloatingText.Type.DAMAGE):
	var floating_text = floating_text_scene.instantiate() as FloatingText
	
	randomize()
	var spawn_offset := Vector2(randf_range(-7, 7), randf_range(-12, -6))
	floating_text.global_position = spawn_position + spawn_offset
	Utils.get_foreground_layer().add_child(floating_text)
	
	floating_text.start(text, type)
