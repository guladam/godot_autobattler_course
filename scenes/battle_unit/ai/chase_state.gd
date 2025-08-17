class_name ChaseState
extends State

signal target_reached(target: BattleUnit)
signal stuck

var actor_unit: BattleUnit
var tween: Tween

func enter() -> void:
	actor_unit = actor as BattleUnit
	
	if _has_target_in_range():
		_end_chase()
	else:
		actor_unit.target_finder.find_target()
		actor_unit.target_finder.targets_in_range_changed.connect(_on_targets_in_range_changed)


func exit() -> void:
	if actor_unit.target_finder.targets_in_range_changed.is_connected(_on_targets_in_range_changed):
		actor_unit.target_finder.targets_in_range_changed.disconnect(_on_targets_in_range_changed)


func chase() -> void:
	if tween and tween.is_running():
		return

	if _has_target_in_range():
		return
	
	actor_unit.target_finder.find_target()
	var new_pos: Vector2 = UnitNavigation.get_next_position(actor_unit, actor_unit.target_finder.target)
	
	# nowhere to go this frame so either the unit is stuck or in range
	if new_pos == Vector2(-1, -1):
		# we might already have a new target if a unit died or something?
		if _has_target_in_range():
			_end_chase()
		else:
			actor_unit.animation_player.play("RESET")
			stuck.emit()
		return
	
	actor_unit.flip_sprite.flip_sprite_towards(new_pos)
	tween = actor_unit.create_tween()
	tween.tween_callback(actor_unit.animation_player.play.bind("move"))
	tween.tween_property(actor_unit, "global_position", new_pos, UnitStats.MOVE_ONE_TILE_SPEED)
	tween.finished.connect(
		func():
			tween.kill()
			
			if _has_target_in_range():
				_end_chase()
			else:
				chase()
	)


func _end_chase() -> void:
	target_reached.emit.call_deferred(actor_unit.target_finder.targets_in_range[0])


func _has_target_in_range() -> bool:
	return actor_unit.target_finder.has_target_in_range()


func _on_targets_in_range_changed() -> void:
	if not tween and _has_target_in_range():
		_end_chase()
