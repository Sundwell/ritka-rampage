class_name WeightedTable
extends Node

var items := []
var total_weight := 0


func add_item(item: Variant, weight: int) -> void:
	items.append({
		"value": item,
		"weight": weight
	})
	total_weight += weight
	
	
func remove_item(item_to_remove: Variant) -> void:
	items = items.filter(func (item): item.value != item_to_remove)
	total_weight = get_items_weight(items)
	
	
func get_items_weight(item_list: Array) -> int:
	return item_list.reduce(
			func (acc: int, item: Variant):
				return item.weight + acc,
			0
	)
	
	
func clear() -> void:
	items.clear()
	total_weight = 0
	
	
func pick_random_item(items_to_exclude: Array = []) -> Variant:
	var available_items = items.filter(
			func (item):
				return not items_to_exclude.has(item.value)
	)
	
	if available_items.size() == 0:
		return null
		
	var total_available_items_weight = get_items_weight(available_items)
	
	var random_weight: int = randi_range(0, total_available_items_weight)
	var weight := 0
	
	for item in available_items:
		weight += item.weight
		
		if weight >= random_weight:
			return item.value
			
	return null
			
			
func pick_random_items(amount: int) -> Array[Variant]:
	var picked_items := []
	
	for i in amount:
		var item = pick_random_item(picked_items)
		
		if not item:
			break
			
		picked_items.append(item)
		
	return picked_items
	
