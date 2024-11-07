extends Node


func pause_game():
	GameEvents.emit_game_paused(true)
	get_tree().paused = true
	
	
func unpause_game():
	GameEvents.emit_game_paused(false)
	get_tree().paused = false
