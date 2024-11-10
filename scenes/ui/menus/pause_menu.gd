extends CanvasLayer

@export var settings_scene: PackedScene
var is_closing := false

@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("default")
	GlobalActions.pause_game()
	panel_container.pivot_offset = panel_container.size / 2
	var tween = create_tween()
	TweenEffect.bouncing_appear(panel_container, tween)
	
	resume_button.pressed.connect(on_resume_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		close()
		get_tree().root.set_input_as_handled()
	
	
func close():
	if is_closing:
		return
		
	is_closing = true
	
	animation_player.play_backwards("default")
	GlobalActions.unpause_game()
	queue_free()


func on_resume_pressed():
	close()
	

func on_settings_pressed():
	var settings_menu = settings_scene.instantiate() as SettingsMenu
	add_child(settings_menu)
	settings_menu.back_pressed.connect(on_settings_back_pressed.bind(settings_menu))
	

func on_settings_back_pressed(settings_menu: SettingsMenu):
	settings_menu.queue_free()


func on_quit_pressed():
	GlobalActions.unpause_game()
	get_tree().change_scene_to_file("res://scenes/ui/menus/main_menu.tscn")
	
	
