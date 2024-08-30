extends Node2D

@export var game_over_screen_scene: PackedScene


func _ready():
	var player = get_tree().get_first_node_in_group('player')
	
	if player != null:
		player.player_died.connect(on_player_died)
		

func on_player_died():
	var game_over_screen = game_over_screen_scene.instantiate()
	game_over_screen.restart_button_pressed.connect(on_restart_button_pressed)
	add_child(game_over_screen)


func on_restart_button_pressed():
	get_tree().reload_current_scene()
