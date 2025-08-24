class_name HailOfArrows
extends UnitAbility

@export var extra_shots_per_tier: Array[int]
@export var time_between_extra_shots: float


func use() -> void:
	var all_enemies := get_tree().get_nodes_in_group(UnitStats.TARGET[caster.stats.team])
	var tween := caster.create_tween()
	
	for _i in extra_shots_per_tier[caster.stats.tier-1]:
		tween.tween_interval(time_between_extra_shots)
		tween.tween_callback(_spawn_extra_projectile.bind(all_enemies))

	tween.finished.connect(ability_cast_finished.emit)


func _spawn_extra_projectile(enemies: Array[Node]) -> void:
	if enemies.is_empty():
		return

	var valid_enemies = enemies.filter(func(obj): return is_instance_valid(obj))
	
	if valid_enemies.is_empty():
		return
	
	SFXPlayer.play(sound)
	var enemy := valid_enemies.pick_random() as BattleUnit
	var projectile := caster.ranged_attack.attack(enemy.global_position) as Projectile
	projectile.target = enemy.global_position
	projectile.hitbox.collision_layer = caster.stats.get_team_collision_layer()
	projectile.hitbox.collision_mask = caster.stats.get_team_collision_mask()
	projectile.hitbox.damage = caster.stats.get_attack_damage()
