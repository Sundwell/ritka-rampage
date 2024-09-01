class_name UpgradeCard
extends Panel

signal selected

@onready var title_label: Label = %TitleLabel
@onready var description_label: Label = %DescriptionLabel


func _ready():
	gui_input.connect(on_gui_input)
	
	
func on_gui_input(event: InputEvent):
	if event.is_action_pressed('left_click'):
		selected.emit()
	

func set_mutation_upgrade(upgrade: MutationUpgrade):
	title_label.text = upgrade.title
	description_label.text = upgrade.description
