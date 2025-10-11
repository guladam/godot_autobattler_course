class_name ModifierHandler
extends Node

@export var modifier_types: Array[Modifier.Type]
var modifiers: Array[Modifier]


func _ready() -> void:
	for type: Modifier.Type in modifier_types:
		var modifier := Modifier.new(type)
		modifiers.append(modifier)


func has_modifier(type: Modifier.Type) -> bool:
	for modifier: Modifier in modifiers:
		if modifier.type == type:
			return true
			
	return false


func get_modifier(type: Modifier.Type) -> Modifier:
	for modifier: Modifier in modifiers:
		if modifier.type == type:
			return modifier
			
	return null


func get_modified_value(base: float, type: Modifier.Type) -> float:
	var modifier := get_modifier(type)
	
	if not modifier:
		return base
		
	return modifier.get_modified_value(base)


func _to_string() -> String:
	var string: PackedStringArray = []
	
	for modifier: Modifier in modifiers:
		string.append(modifier.to_string())
		for value: ModifierValue in modifier.values:
			string.append(value.to_string())
	
	return "\n".join(string)
