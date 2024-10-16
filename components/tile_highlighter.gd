class_name TileHighlighter
extends Node

@export var enabled: bool = true : set = _set_enabled
@export var play_area: PlayArea
@export var highlight_layer: TileMapLayer
@export var tile: Vector2i

@onready var source_id := play_area.tile_set.get_source_id(0)


func _process(_delta: float) -> void:
	if not enabled:
		return

	var selected_tile := play_area.get_hovered_tile()
	
	if not play_area.is_tile_in_bounds(selected_tile):
		highlight_layer.clear()
		return

	_update_tile(selected_tile)


func _set_enabled(new_value: bool) -> void:
	enabled = new_value
	
	if not enabled and play_area:
		highlight_layer.clear()


func _update_tile(selected_tile: Vector2i) -> void:
	highlight_layer.clear()
	highlight_layer.set_cell(selected_tile, source_id, tile)
