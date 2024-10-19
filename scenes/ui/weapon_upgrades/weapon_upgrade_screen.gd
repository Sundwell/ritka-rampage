class_name WeaponUpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: WeaponUpgrade)

@onready var upgrade_card_container: HBoxContainer = %UpgradeCardContainer

@export var upgrade_card_scene: PackedScene


func _ready():
	get_tree().paused = true


func set_weapon_upgrades(upgrades: Array[WeaponUpgrade]):
	for upgrade in upgrades:
		var upgrade_card = upgrade_card_scene.instantiate() as WeaponUpgradeCard
		upgrade_card_container.add_child(upgrade_card)
		
		upgrade_card.set_weapon_upgrade(upgrade)
		upgrade_card.selected.connect(on_upgrade_selected.bind(upgrade))
		

func on_upgrade_selected(upgrade: WeaponUpgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
