class_name TraitTracker
extends Node

signal traits_changed(unique: Dictionary[Trait, int], active: Array[Trait])

@export var arena_grid: UnitGrid

var unique_traits: Dictionary[Trait, int]
var active_traits: Array[Trait]


func _ready() -> void:
	arena_grid.unit_grid_changed.connect(_update_traits)


func _update_traits() -> void:
	var units := arena_grid.get_all_units()
	var unique_trait_list: Array[Trait] = Trait.get_unique_traits_for_units(units)
	active_traits = []
	unique_traits = {}
	
	for current_trait: Trait in unique_trait_list:
		var unique_units := current_trait.get_unique_unit_count(units)
		unique_traits[current_trait] = unique_units
		
		if current_trait.is_active(unique_units):
			active_traits.append(current_trait)
	
	traits_changed.emit(unique_traits, active_traits)
