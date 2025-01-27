extends Node2D

@export var end_screen_scene: PackedScene
@export var pause_scene: PackedScene

var is_arena_timed_out := false


func _ready():
	var player = Utils.get_player()
	
	if player:
		player.health_component.died.connect(on_player_died)
		
	GameEvents.arena_timeout.connect(_on_arena_timeout)
	GameEvents.no_enemies_left.connect(_on_no_enemies_left)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause_menu = pause_scene.instantiate()
		add_child(pause_menu)
		get_tree().root.set_input_as_handled()


func _game_over():
	var end_screen = end_screen_scene.instantiate()
	end_screen.set_defeat()
	add_child(end_screen)


func _game_win():
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
	
	
func _on_no_enemies_left():
	if is_arena_timed_out:
		_game_win()


func on_player_died():
	_game_over()
	
	
func _on_arena_timeout():
	is_arena_timed_out = true
