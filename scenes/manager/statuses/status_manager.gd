class_name StatusManager
extends Node

@export var health_component: HealthComponent
var statuses: Array[Status]


func _add_tick_status(tick_status: TickStatus):
	if tick_status.type == TickStatus.Type.DAMAGE:
		var existing_status: TickStatus
		
		for status in statuses:
			if status is TickStatus and status.type == TickStatus.Type.DAMAGE:
				existing_status = status
		
		if existing_status:
			existing_status.refresh_with(tick_status)
		else:
			add_child(tick_status)
			statuses.append(tick_status)
			tick_status.removed.connect(_on_status_removed.bind(tick_status))
		tick_status.tick.connect(_on_tick.bind(tick_status))


func add_status(status: Status):
	if status is TickStatus:
		_add_tick_status(status)
		
		
func _on_tick(tick_value: float, status: TickStatus):
	if status.type == status.Type.DAMAGE:
		health_component.damage(tick_value)
		
		
func _on_status_removed(status: Status):
	var status_index: int = statuses.find(status)
	
	if status_index != -1:
		statuses.remove_at(status_index)
