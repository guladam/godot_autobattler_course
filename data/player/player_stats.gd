class_name PlayerStats
extends Resource

@export_range(0, 99) var gold: int : set = _set_gold
@export_range(0, 99) var xp: int : set = _set_xp
@export_range(1, 10) var level: int : set = _set_level


func _set_gold(value: int) -> void:
	gold = value
	emit_changed()


func _set_xp(value: int) -> void:
	xp = value
	emit_changed()


func _set_level(value: int) -> void:
	level = value
	emit_changed()
