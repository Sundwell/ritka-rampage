extends CanvasLayer

@export var arena_time_manager: Node

@onready var label: Label = %Label

func _process(delta):
	if arena_time_manager == null:
		return
		
	var time_elapsed = arena_time_manager.get_time_elapsed()
	label.text = format_seconds_to_string(floor(time_elapsed))
	

func format_seconds_to_string(seconds: int):
	var minutes = seconds / 60
	var remaining_seconds = seconds % 60
	
	return str(minutes) + ':' + str(remaining_seconds).lpad(2, '0')
