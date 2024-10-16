extends Node

@export var upgrade_pool: WeaponUpgradesPool
@export var anvil_manager: AnvilManager
@export var upgrade_screen_scene: PackedScene

var current_upgrades: Dictionary = {}
var upgrades_weighted_table: WeightedTable = WeightedTable.new()


func _ready() -> void:
	update_weighted_table()
	GameEvents.anvil_collected.connect(on_anvil_collected)
	
	
func update_weighted_table():
	upgrades_weighted_table.clear()
	
	var available_upgrades: Array[WeaponUpgrade] = upgrade_pool.upgrades.duplicate()
	
	for upgrade: WeaponUpgrade in available_upgrades:
		upgrades_weighted_table.add_item(upgrade, upgrade.weight)
	

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
	
	if upgrade.max_quantity > 0:
		if current_upgrades[upgrade_id]["quantity"] == upgrade.max_quantity:
			upgrade_pool.upgrades = upgrade_pool.upgrades.filter(
					func (pool_upgrade): return pool_upgrade.id != upgrade_id
			)
			update_weighted_table()

	
func pick_upgrades() -> Array[WeaponUpgrade]:
	var items = upgrades_weighted_table.pick_random_items(3)
	
	var weapon_upgrades: Array[WeaponUpgrade] = []
	
	for item in items:
		if item is WeaponUpgrade:
			weapon_upgrades.append(item)
		else:
			push_error("pick_random_items returned not WeaponUpgrade")
	
	return weapon_upgrades
	
	
func on_upgrade_selected(upgrade: WeaponUpgrade) -> void:
	apply_upgrade(upgrade)


func on_anvil_collected() -> void:
	var upgrades_to_show = pick_upgrades() as Array[WeaponUpgrade]
	
	if upgrades_to_show.size() == 0:
		return
		
	var upgrade_screen = upgrade_screen_scene.instantiate() as WeaponUpgradeScreen
	add_child(upgrade_screen)

	upgrade_screen.set_weapon_upgrades(upgrades_to_show)
	upgrade_screen.upgrade_selected.connect(on_upgrade_selected)
