class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = _set_stats

@onready var skin: PackedSprite2D = $Skin
@onready var detect_range: DetectRange = $DetectRange
@onready var hurt_box: HurtBox = $HurtBox
@onready var health_bar := $HealthBar
@onready var mana_bar := $ManaBar
@onready var tier_icon: TierIcon = $TierIcon
@onready var attack_timer: Timer = $AttackTimer
@onready var flip_sprite: FlipSprite = $FlipSprite
@onready var melee_attack: Attack = $MeleeAttack
@onready var target_finder: TargetFinder = $TargetFinder
@onready var unit_ai: UnitAI = $UnitAI
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	hurt_box.hurt.connect(_on_hurt)


func _set_stats(value: UnitStats) -> void:
	stats = value
	
	if not stats or not is_instance_valid(tier_icon):
		return
	
	stats = value.duplicate()
	collision_layer = stats.team + 1
	hurt_box.collision_layer = stats.team + 1
	hurt_box.collision_mask = 2 - stats.team
	
	skin.texture = UnitStats.TEAM_SPRITESHEET[stats.team]
	skin.coordinates = stats.skin_coordinates
	skin.flip_h = stats.team == stats.Team.PLAYER
	
	melee_attack.spawner.scene = stats.melee_attack
	
	detect_range.stats = stats
	tier_icon.stats = stats
	health_bar.stats = stats
	mana_bar.stats = stats
	stats.health_reached_zero.connect(queue_free)


func _on_hurt(damage: int) -> void:
	stats.health -= damage
