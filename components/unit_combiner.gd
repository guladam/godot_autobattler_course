class_name UnitCombiner
extends Node

@export var buffer_timer: Timer

var queued_updates := 0
var tween: Tween


func _ready() -> void:
	buffer_timer.timeout.connect(_on_buffer_timer_timeout)


func queue_unit_combination_update() -> void:
	buffer_timer.start()


func _update_unit_combinations(tier: int) -> void:
	var groups := _group_units_in_tier_by_name(tier)
	var triplets: Array[Array] = _get_triplets_for_groups(groups)

	# if there is nothing to combine, return
	if triplets.is_empty():
		_on_units_combined(tier)
		return

	tween = create_tween()
	
	for combination in triplets:
		tween.tween_callback(_combine_units.bind(combination[0], combination[1], combination[2]))
		tween.tween_interval(UnitAnimations.COMBINE_ANIM_LENGTH)
		
	tween.finished.connect(_on_units_combined.bind(tier), CONNECT_ONE_SHOT)


func _combine_units(unit1: Unit, unit2: Unit, unit3: Unit) -> void:
	unit1.stats.tier += 1
	unit2.remove_from_group("units")
	unit3.remove_from_group("units")
	unit2.animations.play_combine_animation(unit1.global_position + Arena.QUARTER_CELL_SIZE)
	unit3.animations.play_combine_animation(unit1.global_position + Arena.QUARTER_CELL_SIZE)


# Returns a dictionary of units grouped by name and tier where
# keys are unit names,
# values are Arrays of Unit instances.
func _group_units_in_tier_by_name(tier: int) -> Dictionary:
	var units := get_tree().get_nodes_in_group("units")
	var filtered_units := units.filter(
		func(unit: Unit): 
			return unit.stats.tier == tier
	)
	var unit_groups := {}
	
	for unit: Unit in filtered_units:
		if unit_groups.has(unit.stats.name):
			unit_groups[unit.stats.name].append(unit)
		else:
			unit_groups[unit.stats.name] = [unit]
	
	return unit_groups


# Returns all the combinations found in the Dictionary
# returned from the previous method. Combinations are 
# stored in an Array of Arrays, which consist of 3 Unit instances.
func _get_triplets_for_groups(groups: Dictionary) -> Array[Array]:
	var upgrades: Array[Array] = []
	
	for unit_name in groups:
		var current_units: Array = groups[unit_name]
		while current_units.size() >= 3:
			var combination := [current_units[0], current_units[1], current_units[2]]
			upgrades.append(combination)
			current_units = current_units.slice(3)
	
	return upgrades


func _on_buffer_timer_timeout() -> void:
	queued_updates += 1
	
	if not tween or not tween.is_running():
		_update_unit_combinations(1)


func _on_units_combined(tier: int) -> void:
	if tier == 1:
		_update_unit_combinations(2)
	else:
		queued_updates -= 1
		if queued_updates >= 1:
			_update_unit_combinations(1)
