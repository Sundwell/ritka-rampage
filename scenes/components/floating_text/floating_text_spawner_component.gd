extends Node2D

@export var floating_text_scene: PackedScene


func spawn_text(text: String, type: FloatingText.Type = FloatingText.Type.DAMAGE):
	var floating_text = floating_text_scene.instantiate()
	floating_text.global_position = global_position
	get_tree().get_first_node_in_group(Constants.GROUPS.FOREGROUND_LAYER).add_child(floating_text)
	
	floating_text.start(text, type)
