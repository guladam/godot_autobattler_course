class_name Ringring
extends Item

@export var ring_ring_spell: PackedScene


func apply_bonus_effect(battle_unit: BattleUnit) -> void:
	var ability := ring_ring_spell.instantiate() as UnitAbility
	battle_unit.get_tree().root.add_child(ability)
	ability.caster = battle_unit
	ability.ability_cast_finished.connect(ability.queue_free)
	ability.use.call_deferred()
