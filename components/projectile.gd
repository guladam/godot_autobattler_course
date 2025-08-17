@tool
class_name Projectile
extends Node2D

@export var speed: int

var hitbox: HitBox : set = set_hitbox
var visibility_notifier: VisibleOnScreenNotifier2D : set = set_visibility_notifier
var target: Vector2 : set = set_target
var direction: Vector2


func _enter_tree() -> void:
	child_entered_tree.connect(_on_child_entered_tree)
	child_exiting_tree.connect(_on_child_exiting_tree)


func _physics_process(delta: float) -> void:
	if not target:
		return
	
	global_position += direction * speed * delta


func _get_configuration_warnings() -> PackedStringArray:
	if not hitbox or not visibility_notifier:
		return ["Projectiles need to have HitBox and VisibleOnScreenNotifier2D children nodes!"]
	else:
		return []


func set_hitbox(value: HitBox) -> void:
	hitbox = value
	update_configuration_warnings()


func set_visibility_notifier(value: VisibleOnScreenNotifier2D) -> void:
	visibility_notifier = value
	update_configuration_warnings()


func set_target(value: Vector2) -> void:
	target = value
	direction = global_position.direction_to(target)


func _on_child_entered_tree(child: Node) -> void:
	if not hitbox and child is HitBox:
		hitbox = child as HitBox
		hitbox.hit.connect(queue_free)
	
	if not visibility_notifier and child is VisibleOnScreenNotifier2D:
		visibility_notifier = child as VisibleOnScreenNotifier2D
		visibility_notifier.screen_exited.connect(queue_free)


func _on_child_exiting_tree(child: Node) -> void:
	if not Engine.is_editor_hint():
		return
	
	if child == hitbox:
		hitbox.hit.disconnect(queue_free)
		hitbox = null
	
	if child == visibility_notifier:
		visibility_notifier.screen_exited.disconnect(queue_free)
		visibility_notifier = null
	
