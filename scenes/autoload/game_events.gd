extends Node

signal orange_energy_collected(amount: float)


func emit_orange_energy_collected(amount: float):
	orange_energy_collected.emit(amount)
