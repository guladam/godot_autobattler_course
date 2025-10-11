# meta-name: TraitBonus Script
# meta-description: Apply specific bonuses to BattleUnits based on Trait Resources
# meta-default: false
# meta-space-indent: 4
class_name _CLASS_
extends TraitBonus

@export var modifiers: Dictionary[Modifier.Type, ModifierValue]


func apply_bonus(battle_unit: BattleUnit) -> void:
	for type: Modifier.Type in modifiers.keys():
		var unit_modifier := battle_unit.modifier_handler.get_modifier(type)
		unit_modifier.add_new_value(modifiers[type])
