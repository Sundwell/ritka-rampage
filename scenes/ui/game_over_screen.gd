extends CanvasLayer

signal restart_button_pressed

@onready var restart_button: Button = %RestartButton


func _ready():
	get_tree().paused = true
	%RestartButton.pressed.connect(on_restart_button_pressed)


func on_restart_button_pressed():
	get_tree().paused = false
	restart_button_pressed.emit()
