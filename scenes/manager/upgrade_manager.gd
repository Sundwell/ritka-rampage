extends Node

@export var upgrade_pool: Array[MutationUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene
var current_upgrades: Dictionary = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)
	
	
func apply_upgrade(upgrade: MutationUpgrade):
	if not current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	GameEvents.emit_mutation_upgrade_selected(upgrade, current_upgrades)
	
	if upgrade.max_quantity > 0:
		if current_upgrades[upgrade.id]["quantity"] == upgrade.max_quantity:
			upgrade_pool = upgrade_pool.filter(func (pool_upgrade): return pool_upgrade.id != upgrade.id)
	
	
func pick_upgrades() -> Array[MutationUpgrade]:
	var available_upgrades: Array[MutationUpgrade] = upgrade_pool.duplicate()
	var selected_upgrades: Array[MutationUpgrade] = []
	
	for i in 2:
		if available_upgrades.size() == 0:
			break
			
		var random_upgrade = available_upgrades.pick_random() as MutationUpgrade
		selected_upgrades.append(random_upgrade)
		
		available_upgrades = available_upgrades.filter(func (upgrade): return upgrade.id != random_upgrade.id)
	
	return selected_upgrades


func on_upgrade_selected(upgrade: MutationUpgrade):
	apply_upgrade(upgrade)
	
	
func on_level_up(current_level: int):
	var upgrades_to_show: Array[MutationUpgrade] = pick_upgrades()
	
	if upgrades_to_show.size() == 0:
		return
	
	var upgrade_screen = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen)

	upgrade_screen.set_mutation_upgrades(upgrades_to_show)
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)
