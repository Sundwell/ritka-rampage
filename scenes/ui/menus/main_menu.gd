extends CanvasLayer

var main_scene = preload("res://scenes/main/main.tscn")
var settings_scene = preload("res://settings_menu.tscn")

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)
	settings_button.pressed.connect(on_settings_pressed)
	quit_button.pressed.connect(on_quit_pressed)
	
	
func on_play_pressed():
	get_tree().change_scene_to_packed(main_scene)
	

func on_settings_pressed():
	var settings_menu_instance = settings_scene.instantiate() as SettingsMenu
	add_child(settings_menu_instance)
	
	settings_menu_instance.back_pressed.connect(settings_menu_instance.queue_free)
	

func on_quit_pressed():
	get_tree().quit()
	
