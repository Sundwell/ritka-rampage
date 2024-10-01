class_name WeightedTable
extends Node

var items = []
var total_weight := 0


func add_item(item, weight: int):
	items.append({
		"value": item,
		"weight": weight
	})
	total_weight += weight
	
	
func clear():
	items.clear()
	total_weight = 0
	
	
func pick_random_item():
	var random_weight: int = randi_range(0, total_weight)
	
	var weight := 0
	
	for item in items:
		weight += item.weight
		
		if weight >= random_weight:
			return item.value
