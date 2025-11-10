@tool
class_name ModifierValue
extends Resource

enum Type {PERCENT_BASED, FLAT, ZERO}

@export var type: Type
@export var percent_value: float
@export var flat_value: int
@export var source: String


func _init() -> void:
	resource_local_to_scene = true


func _to_string() -> String:
	return "----Type: %s | Source: %s | %%: %s | Flat: %s" % [
		Type.keys()[type],
		source,
		percent_value,
		flat_value
	]
