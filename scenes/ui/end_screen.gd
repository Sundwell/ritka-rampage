extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_container: PanelContainer = $PanelContainer


func _ready():
	GlobalActions.pause_game()
	
	panel_container.pivot_offset = panel_container.size / 2
	panel_container.scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)


func set_defeat():
	%TitleLabel.text = 'You lost'


func on_restart_button_pressed():
	GlobalActions.unpause_game()
	get_tree().reload_current_scene()
	
	
func on_quit_button_pressed():
	get_tree().quit()
