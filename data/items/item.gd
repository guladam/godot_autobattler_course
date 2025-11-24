class_name Item
extends Resource

@export var name: String
@export var id: StringName
@export_multiline var description: String
@export var component: bool
@export var sprite_coordinates: Vector2i
@export var modifiers: Dictionary[Modifier.Type, ModifierValue]

var equip_index := -1


static func find_item(items: Array[Item], item: Item) -> int:
	for i in items.size():
		if items[i].equals(item):
			return i
	
	return -1


func equals(other_item: Item) -> bool:
	return self.id == other_item.id


func apply_modifiers(battle_unit: BattleUnit) -> void:
	for type: Modifier.Type in modifiers.keys():
		var unit_modifier := battle_unit.modifier_handler.get_modifier(type)
		var mod_value := modifiers[type]
		mod_value.source = _get_unique_id()
		unit_modifier.add_new_value(modifiers[type])


# This is overrode by combined items
func apply_bonus_effect(_battle_unit: BattleUnit) -> void:
	pass


func remove_modifiers(battle_unit: BattleUnit) -> void:
	for type: Modifier.Type in modifiers.keys():
		var unit_modifier := battle_unit.modifier_handler.get_modifier(type)
		unit_modifier.remove_value(_get_unique_id())


func _get_unique_id() -> String:
	return "%s_%s" % [id, equip_index]


func _to_string() -> String:
	return "Item: %s (%s) | %s" % [name, _get_unique_id(), description]
