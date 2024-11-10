extends Node2D

@export var end_screen_scene: PackedScene
@export var pause_scene: PackedScene


func _ready():
	%Player.health_component.died.connect(on_player_died)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = pause_scene.instantiate()
		add_child(pause_menu)
		get_tree().root.set_input_as_handled()


func on_player_died():
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
	end_screen.set_defeat()
