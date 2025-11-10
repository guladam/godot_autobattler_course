class_name Modifier
extends RefCounted

signal changed

enum Type {
	UNIT_MAXHEALTH,
	UNIT_MAXMANA,
	UNIT_ATKSPEED,
	UNIT_AD,
	UNIT_AP,
	UNIT_ARMOR,
	UNIT_MAGICRESIST,
	NO_MODIFIER
}

var type: Type
var values: Array[ModifierValue]


func _init(new_type: Type) -> void:
	type = new_type
	values = []


func get_value(source: String) -> ModifierValue:
	for value: ModifierValue in values:
		if value.source == source:
			return value
		
	return null


func add_new_value(value: ModifierValue) -> void:
	var modifier_value := get_value(value.source)
	if not modifier_value:
		values.append(value.duplicate())
		changed.emit()
	else:
		modifier_value.flat_value = value.flat_value
		modifier_value.percent_value = value.percent_value
		changed.emit()


func remove_value(source: String) -> void:
	for value: ModifierValue in values:
		if value.source == source:
			values.erase(value)
			changed.emit()


func clear_values() -> void:
	values.clear()
	changed.emit()


func get_modified_value(base: float) -> float:
	var flat_result: float = base
	var percent_result: float = 1.0
	
	# ZERO modifier overwrites everything and returns 0
	for value: ModifierValue in values:
		if value.type == ModifierValue.Type.ZERO:
			return 0

	# Apply flat modifiers first
	for value: ModifierValue in values:
		if value.type == ModifierValue.Type.FLAT:
			flat_result += value.flat_value
	
	# Apply % modifiers next
	for value: ModifierValue in values:
		if value.type == ModifierValue.Type.PERCENT_BASED:
			percent_result += value.percent_value
			
	return flat_result * percent_result


func _to_string() -> String:
	return "> ModifierType: %s" % [Type.keys()[type]]
