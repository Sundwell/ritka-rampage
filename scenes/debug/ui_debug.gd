extends Node

@export var end_screen_scene: PackedScene

@onready var weapon_upgrade_button: Button = %WeaponUpgradeButton
@onready var mutation_upgrade_button: Button = %MutationUpgradeButton
@onready var lose_button: Button = %LoseButton
@onready var win_button: Button = %WinButton
@onready var weapon_upgrade_manager: Node = %WeaponUpgradeManager
@onready var experience_manager: ExperienceManager = %ExperienceManager


func _ready() -> void:
	weapon_upgrade_button.pressed.connect(weapon_upgrade_manager.on_anvil_collected)
	mutation_upgrade_button.pressed.connect(experience_manager.level_up)
	lose_button.pressed.connect(show_lose_screen)
	win_button.pressed.connect(show_win_screen)


func show_lose_screen():
	var end_screen = end_screen_scene.instantiate()
	end_screen.set_defeat()
	add_child(end_screen)
	
	
func show_win_screen():
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
