extends Node

signal orange_energy_collected(amount: float)
signal mutation_upgrade_selected(upgrade: MutationUpgrade, current_upgrades: Dictionary)


func emit_orange_energy_collected(amount: float):
	orange_energy_collected.emit(amount)


func emit_mutation_upgrade_selected(upgrade: MutationUpgrade, current_upgrades: Dictionary):
	mutation_upgrade_selected.emit(upgrade, current_upgrades)
