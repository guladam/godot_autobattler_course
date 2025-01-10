class_name TeamSizeUI
extends PanelContainer

@export var player_stats: PlayerStats
@export var arena_grid: UnitGrid

@onready var unit_counter: Label = %UnitCounter
@onready var too_many_units_icon: TextureRect = %TooManyUnitsIcon


func _ready() -> void:
	player_stats.changed.connect(_update)
	arena_grid.unit_grid_changed.connect(_update)
	_update()


func _update() -> void:
	var units_used := arena_grid.get_all_units().size()
	unit_counter.text = "%s/%s" % [units_used, player_stats.level]
	too_many_units_icon.visible = units_used > player_stats.level
