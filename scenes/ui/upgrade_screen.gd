class_name UpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: MutationUpgrade)

@onready var upgrade_card_container: HBoxContainer = %UpgradeCardContainer

@export var upgrade_card_scene: PackedScene


func _ready():
	get_tree().paused = true

	
func set_mutation_upgrades(upgrades: Array[MutationUpgrade]):
	for upgrade in upgrades:
		var upgrade_card = upgrade_card_scene.instantiate() as UpgradeCard
		upgrade_card_container.add_child(upgrade_card)
		
		upgrade_card.set_mutation_upgrade(upgrade)
		upgrade_card.selected.connect(on_upgrade_selected.bind(upgrade))
		

func on_upgrade_selected(upgrade: MutationUpgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
