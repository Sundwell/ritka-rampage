extends Node

var experience := 0.0

func _ready():
	GameEvents.orange_energy_collected.connect(on_orange_energy_collected)
	

func increment_experience(amount: float):
	experience += amount
	print(experience)
	

func on_orange_energy_collected(amount: float):
	increment_experience(amount)
