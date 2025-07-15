@icon("res://assets/icons/hurtbox_icon.svg")
class_name HurtBox
extends Area2D

signal hurt(damage: int)


func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _on_area_entered(hitbox: Area2D) -> void:
	if not hitbox is HitBox:
		return
	
	hurt.emit((hitbox as HitBox).damage)
