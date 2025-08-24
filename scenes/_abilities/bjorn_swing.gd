class_name BjornSwing
extends UnitAbility

@export var base_damage_per_tier: Array[int]

@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func use() -> void:
	hit_box.damage = base_damage_per_tier[caster.stats.tier-1]
	hit_box.collision_layer = caster.stats.get_team_collision_layer()
	hit_box.collision_mask = caster.stats.get_team_collision_mask()
	hit_box.damage += caster.stats.ability_power

	SFXPlayer.play(sound)
	animation_player.play("swing")
	animation_player.animation_finished.connect(
		func(_anim_name: String) -> void:
			ability_cast_finished.emit()
	, CONNECT_ONE_SHOT)
