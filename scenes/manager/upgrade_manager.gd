extends Node

signal upgrade_selected

@export var upgrade_pool: Array[MutationUpgrade]
@export var experience_manager: ExperienceManager
@export var upgrade_screen_scene: PackedScene
var current_upgrades: Dictionary = {}


func _ready():
	experience_manager.level_up.connect(on_level_up)


func on_level_up(current_level: int):
	var upgrade_screen = upgrade_screen_scene.instantiate() as UpgradeScreen
	add_child(upgrade_screen)

	upgrade_screen.set_mutation_upgrades(upgrade_pool)
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)
	
	
func apply_upgrade(upgrade: MutationUpgrade):
	if not current_upgrades.has(upgrade.id):
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1

	GameEvents.emit_mutation_upgrade_selected(upgrade, current_upgrades)
	

func on_upgrade_selected(upgrade: MutationUpgrade):
	apply_upgrade(upgrade)
