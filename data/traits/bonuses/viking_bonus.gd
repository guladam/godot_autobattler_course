class_name VikingBonus
extends TraitBonus

@export_range(0.01, 1.0) var hp_threshold_percent: float
@export var modulate_color: Color = Color.CRIMSON
@export var atk_speed_bonus: ModifierValue

var as_modifier: Modifier


func apply_bonus(battle_unit: BattleUnit) -> void:
	battle_unit.stats.changed.connect(_on_battle_unit_stats_changed.bind(battle_unit))
	var as_type := Modifier.Type.UNIT_ATKSPEED
	as_modifier = battle_unit.modifier_handler.get_modifier(as_type)


func _on_battle_unit_stats_changed(battle_unit: BattleUnit) -> void:
	if as_modifier.get_value("viking_trait"):
		return

	if battle_unit.stats.get_health_percentage() <= hp_threshold_percent:
		as_modifier.add_new_value(atk_speed_bonus)
		battle_unit.modulate = modulate_color
