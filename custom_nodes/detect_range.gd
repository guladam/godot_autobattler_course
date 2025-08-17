class_name DetectRange
extends Area2D

@export var col_shape: CollisionShape2D
@export var base_range_size: float
@export var stats: UnitStats:
	set(value):
		stats = value
		collision_layer = 4 * stats.get_team_collision_layer()
		collision_mask = stats.get_team_collision_mask()
		
		var shape := CircleShape2D.new()
		shape.radius = base_range_size * stats.attack_range
		col_shape.shape = shape
