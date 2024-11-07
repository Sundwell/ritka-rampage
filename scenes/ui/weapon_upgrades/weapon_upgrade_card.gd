class_name WeaponUpgradeCard
extends PanelContainer

signal selected

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animator_component: CardAnimatorComponent = $CardAnimatorComponent
@onready var title_panel_container: PanelContainer = %TitlePanelContainer
@onready var quantity_label: Label = %QuantityLabel
@onready var hint_label: Label = %HintLabel
@onready var select_sound: AudioStreamPlayer = $SelectSound
@onready var hover_sound: AudioStreamPlayer = $HoverSound

var disabled := false
var variatons_mapping = {
	WeaponUpgrade.Type.MECHANIC: {
		"main_panel": "WUMechanicPanelContainer",
		"title_panel": "WUTitleMechanicPanelContainer"
	}
}


func _ready():
	animator_component.in_finished.connect(on_in_finished)
	
	
func set_card_variation(type: WeaponUpgrade.Type):
	var variation = variatons_mapping.get(type)
	
	if not variation:
		return
	
	theme_type_variation = variation["main_panel"]
	title_panel_container.theme_type_variation = variation["title_panel"]
	
	
func set_weapon_upgrade(upgrade: WeaponUpgrade, current_upgrades: Dictionary):
	title_label.text = upgrade.title
	description_label.text = upgrade.description
	
	var selected_times = Utils.get_upgrade_quantity(current_upgrades, upgrade.get_id())
	quantity_label.text = '%d/%d' % [selected_times, upgrade.max_quantity]
	
	if not upgrade.hint:
		hint_label.queue_free()
	else:
		hint_label.text = upgrade.hint
	
	set_card_variation(upgrade.type)
	
	
func discard_card():
	disabled = true
	animator_component.play_out()
	
	
func select_card():
	if disabled:
		return
	
	disabled = true
	
	select_sound.play()
	
	animator_component.play_selected()
	var all_cards = get_tree().get_nodes_in_group("weapon_upgrade_card")
	for card: WeaponUpgradeCard in all_cards:
		if card == self:
			continue
		
		card.discard_card()
		
	await animator_component.selected_finished
	selected.emit()
	
	
func on_gui_input(event: InputEvent):
	if event.is_action_pressed('left_click'):
		select_card()


func on_mouse_entered():
	if disabled:
		return
		
	hover_sound.play()
	
	animator_component.play_hover_in()
	
	
func on_mouse_exited():
	if disabled:
		return
	
	animator_component.play_hover_out()
	
	
func on_in_finished():
	gui_input.connect(on_gui_input)
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
