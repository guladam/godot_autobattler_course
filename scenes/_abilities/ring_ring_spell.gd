class_name RingRingSpell
extends UnitAbility

@export var damage: int

@onready var fireball_attack: Attack = $Attack


func use() -> void:
	fireball_attack.parent = caster
	fireball_attack.anchor = caster.ranged_attack.anchor
	fireball_attack.spawn_point = caster.ranged_attack.anchor
	
	var all_enemies := get_tree().get_nodes_in_group(UnitStats.TARGET[caster.stats.team])
	_spawn_projectile(all_enemies)
	ability_cast_finished.emit()


func _spawn_projectile(enemies: Array[Node]) -> void:
	if enemies.is_empty():
		return
	
	var valid_enemies = enemies.filter(
		func(obj): return is_instance_valid(obj)
	)
	
	if valid_enemies.is_empty():
		return
	
	SFXPlayer.play(sound)
	var enemy := valid_enemies.pick_random() as BattleUnit
	var projectile := fireball_attack.attack(enemy.global_position) as Projectile
	projectile.target = enemy.global_position
	projectile.hitbox.damage = damage
