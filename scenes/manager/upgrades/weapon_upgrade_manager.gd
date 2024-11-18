extends Node

@export var upgrade_screen_scene: PackedScene
var current_upgrades: Dictionary = {}

@onready var upgrades_pool_component: WeaponUpgradesPoolComponent = $WeaponUpgradesPoolComponent


func _ready() -> void:
	GameEvents.anvil_collected.connect(on_anvil_collected)


func apply_upgrade(upgrade: WeaponUpgrade):
	var upgrade_id = upgrade.get_id()
	
	if not current_upgrades.has(upgrade_id):
		current_upgrades[upgrade_id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade_id]["quantity"] += 1

	GameEvents.emit_weapon_upgrade_selected(upgrade, current_upgrades)
	
	
func on_upgrade_selected(upgrade: WeaponUpgrade) -> void:
	apply_upgrade(upgrade)


func on_anvil_collected() -> void:
	var upgrades_to_show: Array[WeaponUpgrade] = upgrades_pool_component.pick_upgrades()
	
	if upgrades_to_show.is_empty():
		return
		
	var upgrade_screen = upgrade_screen_scene.instantiate() as WeaponUpgradeScreen
	add_child(upgrade_screen)

	upgrade_screen.set_weapon_upgrades(upgrades_to_show, current_upgrades)
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)
