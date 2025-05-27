class_name StartBattleButton
extends Button

@export var game_state: GameState
@export var player_stats: PlayerStats
@export var arena_grid: UnitGrid

@onready var icon_texture: TextureRect = $Icon


func _ready() -> void:
	pressed.connect(_on_pressed)
	player_stats.changed.connect(_update)
	arena_grid.unit_grid_changed.connect(_update)
	game_state.changed.connect(_update)
	_update()


func _update() -> void:
	var units_used := arena_grid.get_all_units().size()
	var is_battling := game_state.current_phase == GameState.Phase.BATTLE
	
	disabled = is_battling or units_used > player_stats.level or units_used == 0
	icon_texture.modulate.a = 0.5 if disabled else 1.0


func _on_pressed() -> void:
	if game_state.current_phase == GameState.Phase.BATTLE:
		return

	game_state.current_phase = GameState.Phase.BATTLE
	disabled = true
