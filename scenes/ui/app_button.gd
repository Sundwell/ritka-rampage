extends Button

@onready var click_sound: AudioStreamPlayer = $ClickSound


func _ready() -> void:
	gui_input.connect(on_gui_input)
	
	
func on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		click_sound.pitch_scale = randf_range(0.9, 1.1)
		click_sound.play()
