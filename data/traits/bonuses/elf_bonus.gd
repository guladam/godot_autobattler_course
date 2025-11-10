class_name ElfBonus
extends TraitBonus

@export var modifiers: Dictionary[Modifier.Type, ModifierValue]


func apply_bonus(battle_unit: BattleUnit) -> void:
	for type: Modifier.Type in modifiers.keys():
		var unit_modifier := battle_unit.modifier_handler.get_modifier(type)
		unit_modifier.add_new_value(modifiers[type])
