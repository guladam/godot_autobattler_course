class_name XPTracker
extends VBoxContainer

@export var player_stats: PlayerStats

@onready var progress_bar: ProgressBar = %ProgressBar
@onready var xp_label: Label = %XPLabel
@onready var level_label: Label = %LevelLabel


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		player_stats.xp += 4


func _on_player_stats_changed() -> void:
	if player_stats.level < 10:
		_set_xp_bar_values()
	else:
		_set_max_level_values()
	
	level_label.text = "lvl: %s" % player_stats.level


func _set_max_level_values() -> void:
	xp_label.text = "MAX"
	progress_bar.value = 100


func _set_xp_bar_values() -> void:
	var xp_requirement: float = player_stats.get_current_xp_requirement()
	xp_label.text = "%s/%s" % [player_stats.xp, xp_requirement]
	progress_bar.value = (player_stats.xp / xp_requirement) * 100
