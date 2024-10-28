class_name WeaponUpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: WeaponUpgrade)

@onready var upgrade_card_container: HBoxContainer = %UpgradeCardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var upgrade_card_scene: PackedScene


func _ready():
	get_tree().paused = true


func set_weapon_upgrades(upgrades: Array[WeaponUpgrade]):
	var delay := 0.0
	for upgrade in upgrades:
		var upgrade_card = upgrade_card_scene.instantiate() as WeaponUpgradeCard
		upgrade_card_container.add_child(upgrade_card)
		upgrade_card.set_weapon_upgrade(upgrade)
		upgrade_card.selected.connect(on_upgrade_selected.bind(upgrade))
		
		upgrade_card.animator_component.play_in(delay)
		delay += 0.1
		

func on_upgrade_selected(upgrade: WeaponUpgrade):
	upgrade_selected.emit(upgrade)
	animation_player.play("out")
	await animation_player.animation_finished
	get_tree().paused = false
	queue_free()
