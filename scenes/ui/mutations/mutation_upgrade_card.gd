class_name MutationUpgradeCard
extends PanelContainer

signal selected

var disabled := false

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel
@onready var animator_component: CardAnimatorComponent = $CardAnimatorComponent
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var select_sound: AudioStreamPlayer = $SelectSound


func _ready():
	animator_component.in_finished.connect(on_in_finished)
	

func set_mutation_upgrade(upgrade: MutationUpgrade):
	title_label.text = upgrade.title
	description_label.text = upgrade.description
	
	
func discard_card():
	disabled = true
	animator_component.play_out()
	
	
func select_card():
	if disabled:
		return
	
	disabled = true
	
	select_sound.play()
	
	animator_component.play_selected()
	
	var all_cards = get_tree().get_nodes_in_group("mutation_upgrade_card")
	for card: MutationUpgradeCard in all_cards:
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
