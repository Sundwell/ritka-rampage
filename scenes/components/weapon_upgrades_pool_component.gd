class_name WeaponUpgradesPoolComponent
extends Node

var upgrades_list: Array[WeaponUpgrade]
var upgrade_pool: WeightedTable = WeightedTable.new()
var current_upgrades: Dictionary = {}
var collected_anvils_count := 0
var is_weapon_evolved := false


func _ready() -> void:
	GameEvents.weapon_changed.connect(on_weapon_changed)
	GameEvents.weapon_upgrade_selected.connect(on_weapon_upgrade_selected)
	GameEvents.anvil_collected.connect(on_anvil_collected)


func _set_upgrades(new_upgrades: Array[WeaponUpgrade]):
	upgrades_list = new_upgrades.duplicate()
	
	for upgrade: WeaponUpgrade in upgrades_list:
		upgrade_pool.add_item(upgrade, upgrade.weight)
		
		
func _is_upgrade_available(upgrade: WeaponUpgrade) -> bool:
	match upgrade.type:
		WeaponUpgrade.Type.MECHANIC:
			if collected_anvils_count < 2:
				return false
		WeaponUpgrade.Type.EVOLUTION:
			if is_weapon_evolved or collected_anvils_count <= 3:
				return false
				
	return true


func _get_available_upgrades() -> Array[WeaponUpgrade]:
	var available_upgrades: Array[WeaponUpgrade] = upgrades_list.filter(_is_upgrade_available)
	
	return available_upgrades
	
	
func _update_available_upgrades():
	upgrade_pool.clear()
	var available_upgrades: Array[WeaponUpgrade] = _get_available_upgrades()
	
	for upgrade: WeaponUpgrade in available_upgrades:
		upgrade_pool.add_item(upgrade, upgrade.weight)
		
		
func _pick_random_evolution_upgrade() -> WeaponUpgrade:
	var evolution_upgrades: Array[WeaponUpgrade] = upgrades_list.filter(
			func (upgrade: WeaponUpgrade):
				return upgrade.type == WeaponUpgrade.Type.EVOLUTION
	)
	
	if evolution_upgrades.is_empty():
		return null
	
	var random_upgrade_idx := randi_range(0, evolution_upgrades.size() - 1)
	
	return evolution_upgrades[random_upgrade_idx]


func pick_upgrades() -> Array[WeaponUpgrade]:
	_update_available_upgrades()
	var random_picked_upgrades = upgrade_pool.pick_random_items(3)
	
	var picked_upgrades: Array[WeaponUpgrade] = []
	
	for upgrade in random_picked_upgrades:
		if upgrade is WeaponUpgrade:
			picked_upgrades.append(upgrade)
		else:
			push_error("Picked item is not WeaponUpgrade")
	
	var is_evolution_upgrade_in_list: bool = picked_upgrades.any(
			func (upgrade: WeaponUpgrade): 
				return upgrade.type == WeaponUpgrade.Type.EVOLUTION
	)
	
	var should_force_evolution := collected_anvils_count >= 5 and not is_weapon_evolved
	
	if should_force_evolution and not is_evolution_upgrade_in_list:
		var upgrade_to_replace_idx = randi_range(0, picked_upgrades.size() - 1)
		var random_evolution_upgrade: WeaponUpgrade = _pick_random_evolution_upgrade()
		
		if random_evolution_upgrade != null:
			picked_upgrades[upgrade_to_replace_idx] = random_evolution_upgrade
	
	return picked_upgrades
	
	
func on_weapon_changed(new_weapon: Weapon):
	_set_upgrades(new_weapon.upgrades_pool.upgrades)
	
	
func on_weapon_upgrade_selected(upgrade: WeaponUpgrade, selected_upgrades: Dictionary):
	if upgrade.type == WeaponUpgrade.Type.EVOLUTION:
		is_weapon_evolved = true
	
	current_upgrades = selected_upgrades.duplicate()
	
	if upgrade.max_quantity > 0:
		if current_upgrades[upgrade.get_id()]["quantity"] == upgrade.max_quantity:
			upgrades_list.erase(upgrade)
			
			
	var incompatible_upgrade_ids = upgrade.get_incompatible_upgrade_ids()
	
	if not incompatible_upgrade_ids.is_empty():
		upgrades_list = upgrades_list.filter(
				func (weapon_upgrade: WeaponUpgrade):
					return not incompatible_upgrade_ids.has(weapon_upgrade.get_id())
		)


func on_anvil_collected():
	collected_anvils_count += 1
