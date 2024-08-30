class_name ExperienceManager
extends Node

signal experience_updated(current_experience: float, target_experience: float)

const EXPERIENCE_GROWTH = 5

var current_experience := 0.0
var target_experience := 5.0
var level = 1


func _ready():
	GameEvents.orange_energy_collected.connect(on_orange_energy_collected)
	

func increment_experience(amount: float):
	current_experience = min(target_experience, current_experience + amount)
	
	if current_experience == target_experience:
		current_experience = 0.0
		level += 1
		target_experience += EXPERIENCE_GROWTH
		
	experience_updated.emit(current_experience, target_experience)
	

func on_orange_energy_collected(amount: float):
	increment_experience(amount)
