class_name UnitNavigationDebug
extends Node2D

@export var color: Color
@export var path_colors: Array[Color]
@export var game_area: PlayArea

var paths := {}


func _ready() -> void:
	UnitNavigation.path_calculated.connect(_on_path_calculated)


func _draw() -> void:
	for i in UnitNavigation.astar_grid.region.size.x:
		for j in UnitNavigation.astar_grid.region.size.y:
			if UnitNavigation.astar_grid.is_point_solid(Vector2i(i, j)):
				draw_rect(Rect2(Vector2(i, j) * Arena.CELL_SIZE, Arena.CELL_SIZE), color)
	
	var i := 0
	for path in paths.values():
		draw_path(path, path_colors[wrapi(i, 0, path_colors.size()-1)])
		i += 1


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		queue_redraw()


func draw_path(points: Array[Vector2i], path_color: Color) -> void:
	for i in range(1, points.size()):
		var from := game_area.get_global_from_tile(points[i-1]) - global_position
		var to := game_area.get_global_from_tile(points[i]) - global_position
		draw_line(from, to, path_color)


func _on_path_calculated(path: Array[Vector2i], unit: BattleUnit) -> void:
	paths[unit] = path
	queue_redraw()
