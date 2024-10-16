extends CanvasLayer

@export var experience_manager: ExperienceManager


func _ready():
	%ProgressBar.value = 0.0
	
	if experience_manager == null:
		return
		
	experience_manager.experience_updated.connect(on_experience_updated)


func on_experience_updated(current_experience: float, target_experience: float):
	%ProgressBar.value = current_experience / target_experience
