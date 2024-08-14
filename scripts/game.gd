extends Node2D


func _on_player_player_died():
	%GameOverScreen.visible = true
	get_tree().paused = true


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
