class_name MutationUpgradeScreen
extends CanvasLayer

signal upgrade_selected(upgrade: MutationUpgrade)

@export var upgrade_card_scene: PackedScene

@onready var upgrade_card_container: HBoxContainer = %UpgradeCardContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var screen_sound: AudioStreamPlayer = $ScreenSound


func _ready():
	GlobalActions.pause_game()


func set_mutation_upgrades(upgrades: Array[MutationUpgrade]):
	var delay := 0.0
	for upgrade in upgrades:
		var upgrade_card = upgrade_card_scene.instantiate() as MutationUpgradeCard
		upgrade_card_container.add_child(upgrade_card)
		upgrade_card.set_mutation_upgrade(upgrade)
		upgrade_card.selected.connect(on_upgrade_selected.bind(upgrade))
		
		upgrade_card.animator_component.play_in(delay)
		delay += 0.1
		

func on_upgrade_selected(upgrade: MutationUpgrade):
	upgrade_selected.emit(upgrade)
	animation_player.play("out")
	await animation_player.animation_finished
	GlobalActions.unpause_game()
	queue_free()
