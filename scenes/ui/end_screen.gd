extends CanvasLayer

var is_lose_screen := false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_container: PanelContainer = $PanelContainer
@onready var lose_sound: AudioStreamPlayer = $LoseSound
@onready var win_sound: AudioStreamPlayer = $WinSound


func _ready():
	GlobalActions.pause_game()
	
	play_screen_sound()
	
	panel_container.pivot_offset = panel_container.size / 2
	panel_container.scale = Vector2.ZERO
	
	var tween = create_tween()
	tween.tween_property(panel_container, "scale", Vector2.ONE, 0.3) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	%RestartButton.pressed.connect(on_restart_button_pressed)
	%QuitButton.pressed.connect(on_quit_button_pressed)
	
	
func play_screen_sound():
	if is_lose_screen:
		lose_sound.play()
	else:
		win_sound.play()


func set_defeat():
	is_lose_screen = true
	%TitleLabel.text = 'You lost'


func on_restart_button_pressed():
	GlobalActions.unpause_game()
	get_tree().reload_current_scene()
	
	
func on_quit_button_pressed():
	get_tree().quit()
