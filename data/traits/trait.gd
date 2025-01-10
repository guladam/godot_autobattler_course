class_name Trait
extends Resource

const HIGHLIGHT_COLOR_CODE := "fafa82"

@export var name: String
@export var icon: Texture
@export_multiline var description: String

@export_range(1, 5) var levels: int
@export var unit_requirements: Array[int]
@export var unit_modifiers: Array[PackedScene]


func get_unique_unit_count(units: Array[Unit]) -> int:
	units = units.filter(
		func(unit: Unit):
			return unit.stats.traits.has(self)
	)
	
	var unique_units: Array[String] = []
	
	for unit: Unit in units:
		if not unique_units.has(unit.stats.name):
			unique_units.append(unit.stats.name)
	
	return unique_units.size()


func get_levels_bbcode(unit_count: int) -> String:
	var code: PackedStringArray = []
	var reached_level := unit_requirements.filter(
		func(requirement: int):
			return unit_count >= requirement
	)
	
	for i: int in levels:
		if i == (reached_level.size()-1):
			code.append("[color=#%s]%s[/color]" % [HIGHLIGHT_COLOR_CODE, unit_requirements[i]])
		else:
			code.append(str(unit_requirements[i]))
		
	return "/".join(code)


func is_active(unique_unit_count: int) -> bool:
	return unique_unit_count >= unit_requirements[0]


static func get_unique_traits_for_units(units: Array[Unit]) -> Array[Trait]:
	var traits: Array[Trait] = []
	
	for unit: Unit in units:
		for trait_data: Trait in unit.stats.traits:
			if not traits.has(trait_data):
				traits.append(trait_data)
	
	return traits


static func get_trait_names(traits: Array[Trait]) -> PackedStringArray:
	var trait_names: PackedStringArray = []
	
	for current_trait in traits:
		trait_names.append(current_trait.name)
		
	return trait_names
