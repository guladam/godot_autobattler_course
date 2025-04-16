class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

@export var bench: PlayArea
@export var game_area: PlayArea

@onready var unit_scene_spawner: SceneSpawner = $SceneSpawner


func _get_first_available_area() -> PlayArea:
	if not bench.unit_grid.is_grid_full():
		return bench
	elif not game_area.unit_grid.is_grid_full():
		return game_area
	
	return null


func spawn_unit(unit: UnitStats) -> void:
	var area := _get_first_available_area()
	# TODO in the future, throw a popup error message here!
	assert(area, "No available space to add unit to!")
	
	var new_unit := unit_scene_spawner.spawn_scene(area.unit_grid) as Unit
	var tile := area.unit_grid.get_first_empty_tile()
	area.unit_grid.add_unit(tile, new_unit)
	new_unit.global_position = area.get_global_from_tile(tile) - Arena.HALF_CELL_SIZE
	new_unit.stats = unit
	unit_spawned.emit(new_unit)
