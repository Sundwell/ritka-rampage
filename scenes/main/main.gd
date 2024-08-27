extends Node2D

func _ready():
	var player = get_tree().get_first_node_in_group('player')
	
	if player != null:
		player.player_died.connect(_on_player_died)
		

func _on_player_died():
	%GameOverScreen.visible = true
	get_tree().paused = true


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
