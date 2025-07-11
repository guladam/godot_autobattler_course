class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var skin: PackedSprite2D = $Skin
@onready var health_bar := $HealthBar
@onready var mana_bar := $ManaBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var unit_ai: UnitAI = $UnitAI
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if not stats or not is_instance_valid(tier_icon):
		return
	
	stats = value.duplicate()
	collision_layer = stats.team + 1
	
	skin.texture = UnitStats.TEAM_SPRITESHEET[stats.team]
	skin.coordinates = stats.skin_coordinates
	skin.flip_h = stats.team == stats.Team.PLAYER
	tier_icon.stats = stats
