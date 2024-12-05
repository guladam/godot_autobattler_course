class_name GoldDisplay
extends HBoxContainer

@export var player_stats: PlayerStats

@onready var gold: Label = $Gold


func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()


func _on_player_stats_changed() -> void:
	gold.text = str(player_stats.gold)
