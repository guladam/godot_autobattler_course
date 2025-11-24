class_name ItemHandler
extends Node

signal item_removed(item: Item)
signal items_changed

const MAX_ITEMS_HELD := 3

@export var item_db: ItemDB
@export var equipped_items: Array[Item] = []


func _ready() -> void:
	for i in equipped_items.size():
		if equipped_items[i]:
			equipped_items[i].equip_index = i
	
	items_changed.connect(func(): print(equipped_items))


func add_item(new_item: Item) -> bool:
	# Get recipe for combining new item with an existing one
	var recipe := item_db.get_recipe_for_new_item(equipped_items, new_item)
	
	# If there's one, we combine them
	if recipe:
		_combine_components(recipe, new_item)
		return true
	
	# If not, we try to equip the item as is
	return _try_equipping_item(new_item)


func _remove_item(idx: int) -> void:
	var item := equipped_items[idx]
	equipped_items[idx] = null
	item_removed.emit(item)


func copy_items_to(other_handler: ItemHandler) -> void:
	other_handler.equipped_items.clear()
	for item: Item in equipped_items:
		other_handler.add_item(item)


func _combine_components(recipe: ItemRecipe, new_item: Item) -> void:
	var equipped_component := recipe.get_other_source_item(new_item)
	var idx := Item.find_item(equipped_items, equipped_component)
	_remove_item(idx)
	equipped_items[idx] = recipe.result
	equipped_items[idx].equip_index = idx
	items_changed.emit()


func _try_equipping_item(item: Item) -> bool:
	if equipped_items.size() >= MAX_ITEMS_HELD:
		print("No available item slots!")
		return false
	
	equipped_items.append(item)
	equipped_items[-1].equip_index = equipped_items.size()-1
	items_changed.emit()
	return true
