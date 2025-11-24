class_name ItemRecipe
extends Resource

@export var source_item_1: Item
@export var source_item_2: Item
@export var result: Item


func can_be_combined(item1: Item, item2: Item) -> bool:
	var match_1 := source_item_1.id == item1.id
	var match_2 := source_item_2.id == item2.id
	var cross_match_1 := source_item_1.id == item2.id
	var cross_match_2 := source_item_2.id == item1.id
	
	return (match_1 and match_2) or (cross_match_1 and cross_match_2)


func get_other_source_item(item: Item) -> Item:
	if source_item_1.id == item.id:
		return source_item_2
	if source_item_2.id == item.id:
		return source_item_1
	
	return null
