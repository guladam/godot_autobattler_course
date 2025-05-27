class_name XPButton
extends Button

@export var player_stats: PlayerStats
@export var gold_cost: int = 4
@export var xp_provided: int = 4
@export var xp_sound: AudioStream

@onready var vbox_container: VBoxContainer = $VBoxContainer


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	var has_enough_gold := player_stats.gold >= gold_cost
	var max_level := player_stats.level == PlayerStats.MAX_LEVEL
	disabled = not has_enough_gold or max_level
	
	if has_enough_gold and not max_level:
		vbox_container.modulate.a = 1.0
	else:
		vbox_container.modulate.a = 0.5


func _on_pressed() -> void:
	player_stats.gold -= gold_cost
	player_stats.xp += xp_provided
	SFXPlayer.play(xp_sound)
