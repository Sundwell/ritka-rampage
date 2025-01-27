class_name ExperienceManager
extends Node

signal experience_updated(current_experience: float, target_experience: float)
signal leveled_up(new_level: int)

const EXPERIENCE_GROWTH = 2

var current_experience := 0.0
var target_experience := 15.0
var level := 1


func _ready():
	GameEvents.orange_energy_collected.connect(on_orange_energy_collected)
	
	
func level_up():
	current_experience = 0.0
	level += 1
	leveled_up.emit(level)
	target_experience += EXPERIENCE_GROWTH
	

func increment_experience(amount: float):
	current_experience = min(target_experience, current_experience + amount)
	
	if current_experience == target_experience:
		level_up()
		
	experience_updated.emit(current_experience, target_experience)
	

func on_orange_energy_collected(amount: float):
	increment_experience(amount)
